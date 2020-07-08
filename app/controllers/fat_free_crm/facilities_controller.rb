# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCrm
  class FacilitiesController < EntitiesController
    include ActionView::Helpers::TagHelper
    before_action :get_data_for_sidebar, only: :index
    before_action :get_facilities, only: %i[show create_case]

    # GET /facilities
    #----------------------------------------------------------------------------
    def index
      @facilities = get_facilities(page: page_param, per_page: per_page_param)

      respond_with @facilities do |format|
        format.xls { render layout: 'header' }
        format.csv { render csv: @facilities }
        format.html { render "index_lite" }
      end
    end

    # GET /facilities/1
    # AJAX /facilities/1
    #----------------------------------------------------------------------------
    def show
      @stage = Setting.unroll(:opportunity_stage)
      @comment = Comment.new
      @timeline = timeline(@facility)
      respond_with(@facility)
    end

    def create_case
      @facility_index = get_facilities.index(@facility)
      @facility.facility_facility_cases.create

      redirect_to facility_cases_path, flash: {notice: 'Facility Case Created Successfully.'}
    end

    # POST /facilities/filter                                                  AJAX
    #----------------------------------------------------------------------------
    def filter
      session[:facilities_filter] = params[:category]
      @facilities = get_facilities(page: 1, per_page: per_page_param)

      respond_with(@facilities) do |format|
        format.js { render :index }
      end
    end

    private

    #----------------------------------------------------------------------------
    alias get_facilities get_list_of_records

    #----------------------------------------------------------------------------
    def list_includes
      %i[user tags].freeze
    end

    #----------------------------------------------------------------------------
    def get_data_for_sidebar
      @account_category_total = HashWithIndifferentAccess[
                                Setting.account_category.map do |key|
                                  [key, Account.my(current_user).where(category: key.to_s).count]
                                end
      ]
      categorized = @account_category_total.values.sum
      @account_category_total[:all] = Account.my(current_user).count
      @account_category_total[:other] = @account_category_total[:all] - categorized
    end
  end
end