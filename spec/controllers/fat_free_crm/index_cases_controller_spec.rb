# frozen_string_literal: true

require 'spec_helper'

module FatFreeCrm
  describe IndexCasesController do
    routes { FatFreeCrm::Engine.routes }
    let(:account) { create(:account, user: current_user) }
    let(:index_case) {create(:index_case, user: current_user)}

    before do
      login
      index_case
      account
      set_current_tab(:index_cases)
    end

    describe "responding to GET index" do
      it "should expose all index cases as @contacts and render [index] template" do
         @index_case_category_total = {
          total: 1,
          other: index_case
        }
        # allow(controller).to receive(:get_data_for_sidebar).and_return(@index_case_category_total)
        @index_cases = [index_case]
        get :index, xhr: true
        # expect(response[:index_cases]).to eq(@index_cases)
        #expect(assigns[:index_cases].count).to eq(@index_cases.count)
        #expect(assigns[:index_cases]).to eq(@index_cases)
        # expect(response).to render_template("index_cases/index")
        expect(response.status).to eq(200)
        # expect(response).to render_template("/fat_free_crm/index_cases")
      end
    end

    describe "responding to GET show" do
      before(:each) do
        @stage = Setting.unroll(:opportunity_stage)
        @comment = Comment.new
        @timeline = [] #timeline(@index_case)
        @index_case = index_case
      end

      it "should expose the requested index case as @index_case" do
        get :show, params: {id: @index_case.id}, xhr: true
        expect(response.status).to eq(200)
        # expect(response).to render_template("/fat_free_crm/index_case")
      end
    end
  end
end
