# frozen_string_literal: true

require 'spec_helper'

module FatFreeCrm
  describe IndexCasesController do
    routes { FatFreeCrm::Engine.routes }
    let(:account) { create(:account, user: current_user) }
    let(:contact) { create(:contact) }
    let(:index_case) {create(:index_case, user: current_user, contact: contact, id: 50)}
    render_views

    before do
      login
      index_case
      account
      set_current_tab(:index_cases)
    end

    describe "responding to GET new" do
      it "should expose a new index_case as @index_case and render [new] template" do
        get :new, xhr: true
        expect(assigns[:index_case].class).to eq(FatFreeCrm::IndexCase)
        expect(assigns[:index_case].persisted?).to eq(false)
        expect(response.status).to eq(200)
        # expect(response).to render_template("index_cases/new")
      end
    end

    describe "responding to GET edit" do
      it "should expose the requested contact as @index_case and render [edit] template" do
        @previous = index_case
        allow(IndexCase).to receive(:my).with(current_user).and_return(index_case)

        get :edit, params: { id: 50 }, xhr: true
        expect(assigns[:previous]).to eq(@index_case)
        expect(response.status).to eq(200)
        # expect(response).to render_template("contacts/edit")
      end
    end

    describe "responding to POST create" do
      # NOTE: There are no validations on IndexCase
      describe "with valid params" do
        it "should expose a newly created contact as @index_case and render [create] template" do
          @index_case = IndexCase.new
          allow(IndexCase).to receive(:new).and_return(@index_case)

          post :create,
          params: {
            index_case: {
              user_id: current_user.id,
              access: 'Public',
              window_start_date: "2020-01-01",
              window_end_date: "2020-02-02",
              projected_return_date: "2020-04-04",
              contact_id: contact.id
            }
          },
          xhr: true
          expect(assigns(:index_case)).to eq(@index_case)
          expect(response.status).to eq(200)
          expect(IndexCase.last.user_id).to eq(current_user.id)
          # expect(assigns(:index_case).reload.persisted?).to eq(true)
          # expect(response).to render_template("index_case/create")
        end
      end
    end

    describe "responding to GET redraw" do
      it "should save user selected index case preference" do
        get :redraw, params: { per_page: 42, view: "brief", sort_by: "user_id" }, xhr: true
        expect(response.status).to eq(200)
      end
    end

    describe "responding to GET advanced_search" do
      xit "" do

      end
    end

    describe "responding to POST filter" do
      it "should respond with a filtered index case collection" do
        post :filter, xhr: true
        expect(response.status).to eq(200)
      end
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

    context "records referencing index_cases" do
      describe "responding to GET new_exposure" do
        xit "should build an exposure for an existing index_case" do
          @index_case = create(:index_case, user: current_user, contact: contact)
          get :new_exposure, params: {id: @index_case.id}, xhr: true
          #expect(assigns(:index_case)).to eq(@index_case)
          #expect(assigns(:index_case).exposures).to include(assigns(:exposure))
          expect(response.status).to eq(200)
          expect(response.content_type).to eq("text/javascript; charset=utf-8")
        end

        xit "should build a new index case and absence if no persisted index case" do
          get :new_exposure, params: {}, xhr: true
          # expect(assigns(:index_case).persisted?).to eq(false)
          # expect(assigns(:index_case).exposures).to include(assigns(:exposure))
          expect(response.status).to eq(200)
          expect(response.content_type).to eq("text/javascript; charset=utf-8")
        end
      end

      describe "responding to GET new_investigation" do
        xit "should build an investigation for an existing index case" do
          @index_case = index_case
          get :new_investigation, params: {id: @index_case.id}, xhr: true
          # expect(assigns(:index_case)).to eq(@index_case)
          # expect(assigns(:index_case).investigations).to include(assigns(:investigation))
          expect(response.status).to eq(200)
          expect(response.content_type).to eq("text/javascript; charset=utf-8")
        end

        xit "should build a new index case and investigation if no persisted index case" do
          get :new_investigation, params: {}, xhr: true
          # expect(assigns(:index_case).persisted?).to eq(false)
          # expect(assigns(:index_case).investigations).to include(assigns(:investigation))
          expect(response.status).to eq(200)
          expect(response.content_type).to eq("text/javascript; charset=utf-8")
        end
      end
    end

    describe "UPDATE action" do
      let(:index_case) { create(:index_case, user: current_user, access: "Public") }
      let(:contact) { create(:contact, user: current_user, access: "Public") }
      it 'creates absences for exposed people' do
        put :update, params: { id: index_case.id, index_case: { exposures_attributes: { 0 => { start_on: 3.days.ago, end_on: 1.day.ago, contact: contact} } } }, xhr: true
        puts response.body.inspect
        expect(contact.reload.absences).to_not be_empty
      end
    end
  end
end
