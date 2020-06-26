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
      @index_case.build_index_case_investigation if @index_case.index_case_investigation.blank?

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
        binding.pry
        # Must set access before user_ids, because user_ids= method depends on access value.
        @index_case.access = params[:index_case][:access] if params[:index_case][:access]
        result = IndexCases::Update.new.call(index_case: @index_case, params: index_case_params)
        if result.success?
          if params['projected_return_date'].present?
            absence = Absences::FindOrCreate.new.call(contact: @index_case.contact, 
                                                absence_params: {
                                                  kind: 'covid_19_isolation',
                                                  start_on: params['projected_return_date'],
                                                  end_on: params['projected_return_date'] + 14.days
                                                })
          end
          get_data_for_sidebar
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
      @exposure = @index_case.exposures.build
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
    
    def index_case_params
      params.require(:index_case).permit(:projected_return_date, 
        index_case_investigation: [:interview_at, :onset_of_symptoms, :infectious_period_start_at, :infectious_period_end_at, :isolation_period_start_at, :isolation_period_end_at, :self_isolate, symptoms: []],
        clinical_investigations_attributes: [:id, :interview_at, :projected_return_date, :health_event, :event_on, :contact_representative, :contact_representative_id, :health_care_provider_contact, :health_care_provider_contact_id, :contact_representative_relationship_kind]
        )
    end
  end
end