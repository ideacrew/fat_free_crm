# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCrm
  class IndexCasesController < EntitiesController
    before_action :get_data_for_sidebar, only: :index

    # GET /index_cases
    #----------------------------------------------------------------------------
    def index
      @index_cases = get_index_cases(page: page_param, per_page: per_page_param)

      respond_with @index_cases do |format|
        format.xls { render layout: 'header' }
        format.csv { render csv: @index_cases }
      end
    end

    # GET /index_cases/1
    # AJAX /index_cases/1
    #----------------------------------------------------------------------------
    def show
      @stage = Setting.unroll(:opportunity_stage)
      @comment = Comment.new
      @timeline = [] #timeline(@index_case)
      respond_with(@index_case)
    end

    # GET /index_cases/new
    #----------------------------------------------------------------------------
    def new
      @index_case.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }
      get_opportunities

      if params[:related]
        model, id = params[:related].split('_')
        instance_variable_set("@#{model}", "FatFreeCrm::#{model.classify}".constantize.find(id))
      end

      respond_with(@index_case)
    end

    # GET /index_cases/1/edit                                                   AJAX
    #----------------------------------------------------------------------------
    def edit
      @previous = IndexCase.my(current_user).find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i if params[:previous].to_s =~ /(\d+)\z/
      get_opportunities

      respond_with(@index_case)
    end

    # POST /index_cases
    #----------------------------------------------------------------------------
    def create
      get_opportunities
      @comment_body = params[:comment_body]
      respond_with(@index_case) do |_format|
        if @index_case.save
          @index_case.add_comment_by_user(@comment_body, current_user)
          # None: index_case can only be created from the index_cases index page, so we
          # don't have to check whether we're on the index page.
          @index_cases = get_index_cases
          get_data_for_sidebar
        end
      end
    end

    # PUT /index_cases/1
    #----------------------------------------------------------------------------
    def update
      respond_with(@index_case) do |_format|
        # Must set access before user_ids, because user_ids= method depends on access value.
        @index_case.access = params[:index_case][:access] if params[:index_case][:access]
        if @index_case.update!(resource_params)
          get_data_for_sidebar
          @index_case.exposures.each do |exposure|
            unless exposure.contact.absences.any? { |absence| absence.kind == 'covid_19_quarantine' && exposure.ended_at && absence.end_on > exposure.ended_at }
              exposure.contact.absences.create(kind: 'covid_19_quarantine',
                start_on: exposure.ended_at.beginning_of_day,
                end_on: exposure.ended_at.end_of_day + 13.days)
            end
          end
        end
      end
    end

    # DELETE /index_cases/1
    #----------------------------------------------------------------------------
    def destroy
      @index_case.destroy

      respond_with(@index_case) do |format|
        format.html { respond_to_destroy(:html) }
        format.js   { respond_to_destroy(:ajax) }
      end
    end

    # PUT /index_cases/1/attach
    #----------------------------------------------------------------------------
    # Handled by EntitiesController :attach

    # PUT /index_cases/1/discard
    #----------------------------------------------------------------------------
    # Handled by EntitiesController :discard

    # POST /index_cases/auto_complete/query                                     AJAX
    #----------------------------------------------------------------------------
    # Handled by ApplicationController :auto_complete

    # GET /index_cases/redraw                                                   AJAX
    # ----------------------------------------------------------------------------
    def redraw
      current_user.pref[:index_cases_per_page] = per_page_param if per_page_param
      current_user.pref[:index_cases_sort_by]  = FatFreeCrm::IndexCase.sort_by_map[params[:sort_by]] if params[:sort_by]
      @index_cases = get_index_cases(page: 1, per_page: per_page_param)
      set_options # Refresh options

      respond_with(@index_cases) do |format|
        format.js { render :index }
      end
    end

    # POST /index_cases/filter                                                  AJAX
    #----------------------------------------------------------------------------
    def filter
      session[:index_cases_filter] = params[:category]
      @index_cases = get_index_cases(page: 1, per_page: per_page_param)

      respond_with(@index_cases) do |format|
        format.js { render :index }
      end
    end

    def new_exposure
      # TODO: Look into if this is needed here if index case can be nil
      # index_case = FatFreeCrm::IndexCase.find_by(id: params[:id])
      # @index_case = index_case.present? ? index_case : FatFreeCrm::IndexCase.new
      @exposure = @index_case.exposures.build
    end

    def new_investigation
      # TODO: Look into if this is needed here if index case can be nil
      # index_case = FatFreeCrm::IndexCase.find_by(id: params[:id])
      # @index_case = index_case.present? ? index_case : FatFreeCrm::IndexCase.new
      @investigation = @index_case.investigations.build
    end

    def decrypt_email_link
      signature = params[:signature]
      link = verifier.verify(signature)

      redirect_to link
    end

    private

    # #----------------------------------------------------------------------------
    alias get_index_cases get_list_of_records

    #----------------------------------------------------------------------------
    def list_includes
      %i[user tags].freeze
    end

    #----------------------------------------------------------------------------
    def get_opportunities
      @opportunities = FatFreeCrm::Opportunity.my(current_user).order('name')
    end

    #----------------------------------------------------------------------------
    def respond_to_destroy(method)
      if method == :ajax
        @index_cases = get_index_cases
        get_data_for_sidebar
        if @index_cases.empty?
          @index_cases = get_index_cases(page: current_page - 1) if current_page > 1
          render(:index) && return
        end
        # At this point render default destroy.js
      else # :html request
        self.current_page = 1 # Reset current page to 1 to make sure it stays valid.
        flash[:notice] = t(:msg_asset_deleted, @index_case.contact.full_name)
        redirect_to index_cases_path
      end
    end

    #----------------------------------------------------------------------------
    def get_data_for_sidebar
      @index_case_category_total = HashWithIndifferentAccess[
                                Setting.index_case_category.map do |key|
                                  [key, IndexCase.my(current_user).where(category: key.to_s).count]
                                end
      ]
      categorized = @index_case_category_total.values.sum
      @index_case_category_total[:all] = IndexCase.my(current_user).count
      @index_case_category_total[:other] = @index_case_category_total[:all] - categorized
    end
  end
end