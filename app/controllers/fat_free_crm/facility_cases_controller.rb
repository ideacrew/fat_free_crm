# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCrm
  class FacilityCasesController < EntitiesController
    before_action :get_data_for_sidebar, only: :index

    # GET /facility_cases
    #----------------------------------------------------------------------------
    def index
      @facility_cases = get_facility_cases(page: page_param, per_page: per_page_param)

      respond_with @facility_cases do |format|
        format.xls { render layout: 'header' }
        format.csv { render csv: @facility_cases }
      end
    end

    # GET /facility_cases/1
    # AJAX /facility_cases/1
    #----------------------------------------------------------------------------
    def show
      @stage = Setting.unroll(:opportunity_stage)
      @comment = Comment.new
      @timeline = timeline(@facility_case)
      respond_with(@facility_case)
    end

    # GET /facility_cases/new
    #----------------------------------------------------------------------------
    def new
      @facility_case.attributes = { user: current_user, access: Setting.default_access, assigned_to: nil }
      get_opportunities

      if params[:related]
        model, id = params[:related].split('_')
        instance_variable_set("@#{model}", "FatFreeCrm::#{model.classify}".constantize.find(id))
      end

      respond_with(@facility_case)
    end

    # GET /facility_cases/1/edit                                                   AJAX
    #----------------------------------------------------------------------------
    def edit
      @previous = IndexCase.my(current_user).find_by_id(Regexp.last_match[1]) || Regexp.last_match[1].to_i if params[:previous].to_s =~ /(\d+)\z/
      get_opportunities
      @facility_case.build_facility_case_investigation if @facility_case.facility_case_investigation.blank?
      @facility_case.build_contact_elicitation_investigation if @facility_case.contact_elicitation_investigation.blank?
      respond_with(@facility_case)
    end

    # POST /facility_cases
    #----------------------------------------------------------------------------
    def create
      get_opportunities
      @comment_body = params[:comment_body]
      respond_with(@facility_case) do |_format|
        if @facility_case.save
          @facility_case.add_comment_by_user(@comment_body, current_user)
          # None: facility_case can only be created from the facility_cases index page, so we
          # don't have to check whether we're on the index page.
          @facility_cases = get_facility_cases
          get_data_for_sidebar
        end
      end
    end

    # PUT /facility_cases/1
    #----------------------------------------------------------------------------
    def update
      respond_with(@facility_case) do |_format|
        # Must set access before user_ids, because user_ids= method depends on access value.
        @facility_case.access = params[:facility_case][:access] if params[:facility_case][:access]
        result = FacilityCases::Update.new.call(facility_case: @facility_case, params: facility_case_filtered_params)
        if result.success?
          get_data_for_sidebar
        end
      end
    end

    # DELETE /facility_cases/1
    #----------------------------------------------------------------------------
    def destroy
      @facility_case.destroy

      respond_with(@facility_case) do |format|
        format.html { respond_to_destroy(:html) }
        format.js   { respond_to_destroy(:ajax) }
      end
    end

    # PUT /facility_cases/1/attach
    #----------------------------------------------------------------------------
    # Handled by EntitiesController :attach

    # PUT /facility_cases/1/discard
    #----------------------------------------------------------------------------
    # Handled by EntitiesController :discard

    # POST /facility_cases/auto_complete/query                                     AJAX
    #----------------------------------------------------------------------------
    # Handled by ApplicationController :auto_complete

    # GET /facility_cases/redraw                                                   AJAX
    # ----------------------------------------------------------------------------
    def redraw
      current_user.pref[:facility_cases_per_page] = per_page_param if per_page_param
      current_user.pref[:facility_cases_sort_by]  = FatFreeCrm::IndexCase.sort_by_map[params[:sort_by]] if params[:sort_by]
      @facility_cases = get_facility_cases(page: 1, per_page: per_page_param)
      set_options # Refresh options

      respond_with(@facility_cases) do |format|
        format.js { render :index }
      end
    end

    # POST /facility_cases/filter                                                  AJAX
    #----------------------------------------------------------------------------
    def filter
      session[:facility_cases_filter] = params[:category]
      @facility_cases = get_facility_cases(page: 1, per_page: per_page_param)

      respond_with(@facility_cases) do |format|
        format.js { render :index }
      end
    end

    def new_exposure
      @exposure = @facility_case.exposures.build
    end

    def decrypt_email_link
      signature = params[:signature]
      link = verifier.verify(signature)

      redirect_to link
    end

    private

    # #----------------------------------------------------------------------------
    alias get_facility_cases get_list_of_records

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
        @facility_cases = get_facility_cases
        get_data_for_sidebar
        if @facility_cases.empty?
          @facility_cases = get_facility_cases(page: current_page - 1) if current_page > 1
          render(:index) && return
        end
        # At this point render default destroy.js
      else # :html request
        self.current_page = 1 # Reset current page to 1 to make sure it stays valid.
        flash[:notice] = t(:msg_asset_deleted, @facility_case.facility.name)
        redirect_to facility_cases_path
      end
    end

    #----------------------------------------------------------------------------
    def get_data_for_sidebar
      @facility_case_category_total = HashWithIndifferentAccess[
                                Setting.facility_case_category.map do |key|
                                  [key, IndexCase.my(current_user).where(category: key.to_s).count]
                                end
      ]
      categorized = @facility_case_category_total.values.sum
      @facility_case_category_total[:all] = IndexCase.my(current_user).count
      @facility_case_category_total[:other] = @facility_case_category_total[:all] - categorized
    end

    def facility_case_filtered_params
      params.require(:facility_case).permit(:projected_return_date, :absence_begin_date, :investigation_kind, :user_id,
        facility_case_investigation_attributes: [:interview_at, :contact_representative, :contact_representative_id, :case_reference],
        contact_elicitation_investigation_attributes: [:id, :_destroy, :interview_at, :contact_representative, :contact_representative_id, :contact_representative_relationship_kind,
          contact_exposure_cases_attributes: [:id, :_destroy, :contact_id, :contact, contact_exposure_detail_attributes: [:exposure_started_at, :exposure_ended_at, :used_mask, :exposure_level]]
        ],
        facility_facility_case_attributes: [:id, facility_exposure_detail_attributes: [:exposure_started_at, :exposure_ended_at]])
    end
  end
end