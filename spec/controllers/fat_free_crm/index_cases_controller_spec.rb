# frozen_string_literal: true

require 'spec_helper'

module FatFreeCrm
  describe IndexCasesController do
    routes { FatFreeCrm::Engine.routes }

    def get_data_for_sidebar
      @category = Setting.index_case_category.dup
    end

    before do
      login_admin
      set_current_tab(:index_cases)
    end

    # GET /index_cases
    # GET /index_cases.xml
    #----------------------------------------------------------------------------
    describe "responding to GET index" do
      before(:each) do
        get_data_for_sidebar
      end

      it "should expose all index_cases as @index_cases and render [index] template" do
        @index_cases = [create(:index_case, user: current_user)]
        get :index
        expect(assigns[:index_cases]).to eq(@index_cases)
        expect(response).to render_template("index_cases/index")
      end

      it "should collect the data for the index_cases sidebar" do
        @index_cases = [create(:index_case, user: current_user)]

        get :index
        expect(assigns[:index_case_category_total].keys.map(&:to_sym) - (@category << :all << :other)).to eq([])
      end

      describe "AJAX pagination" do
        it "should pick up page number from params" do
          @index_cases = [create(:index_case, user: current_user)]
          get :index, params: { page: 42 }, xhr: true

          expect(assigns[:current_page].to_i).to eq(42)
          expect(assigns[:index_cases]).to eq([]) # page #42 should be empty if there's only one index_case ;-)
          expect(session[:index_cases_current_page].to_i).to eq(42)
          expect(response).to render_template("index_cases/index")
        end

        it "should pick up saved page number from session" do
          session[:index_cases_current_page] = 42
          @index_cases = [create(:index_case, user: current_user)]
          get :index, xhr: true

          expect(assigns[:current_page]).to eq(42)
          expect(assigns[:index_cases]).to eq([])
          expect(response).to render_template("index_cases/index")
        end

        it "should reset current_page when query is altered" do
          session[:index_cases_current_page] = 42
          session[:index_cases_current_query] = "bill"
          @index_cases = [create(:index_case, user: current_user)]
          get :index, xhr: true

          expect(assigns[:current_page]).to eq(1)
          expect(assigns[:index_cases]).to eq(@index_cases)
          expect(response).to render_template("index_cases/index")
        end
      end

      describe "with mime type of JSON" do
        it "should render all index_cases as json" do
          expect(@controller).to receive(:get_index_cases).and_return(index_cases = double("Array of index_cases"))
          expect(index_cases).to receive(:to_json).and_return("generated JSON")

          request.env["HTTP_ACCEPT"] = "application/json"
          get :index
          expect(response.body).to eq("generated JSON")
        end
      end

      describe "with mime type of XML" do
        it "should render all index_cases as xml" do
          expect(@controller).to receive(:get_index_cases).and_return(index_cases = double("Array of index_cases"))
          expect(index_cases).to receive(:to_xml).and_return("generated XML")

          request.env["HTTP_ACCEPT"] = "application/xml"
          get :index
          expect(response.body).to eq("generated XML")
        end
      end
    end

    # GET /index_cases/1
    # GET /index_cases/1.xml                                                    HTML
    #----------------------------------------------------------------------------
    describe "responding to GET show" do
      describe "with mime type of HTML" do
        before do
          @index_case = create(:index_case, user: current_user)
          @stage = Setting.unroll(:opportunity_stage)
          @comment = Comment.new
        end

        it "should expose the requested index_case as @index_case and render [show] template" do
          get :show, params: { id: @index_case.id }
          expect(assigns[:index_case]).to eq(@index_case)
          expect(assigns[:stage]).to eq(@stage)
          expect(assigns[:comment].attributes).to eq(@comment.attributes)
          expect(response).to render_template("index_cases/show")
        end

        it "should update an activity when viewing the index_case" do
          get :show, params: { id: @index_case.id }
          expect(@index_case.versions.last.event).to eq('view')
        end
      end

      describe "with mime type of JSON" do
        it "should render the requested index_case as json" do
          @index_case = create(:index_case, user: current_user)
          expect(IndexCase).to receive(:find).and_return(@index_case)
          expect(@index_case).to receive(:to_json).and_return("generated JSON")

          request.env["HTTP_ACCEPT"] = "application/json"
          get :show, params: { id: 42 }
          expect(response.body).to eq("generated JSON")
        end
      end

      describe "with mime type of XML" do
        it "should render the requested index_case as xml" do
          @index_case = create(:index_case, user: current_user)
          expect(IndexCase).to receive(:find).and_return(@index_case)
          expect(@index_case).to receive(:to_xml).and_return("generated XML")

          request.env["HTTP_ACCEPT"] = "application/xml"
          get :show, params: { id: 42 }
          expect(response.body).to eq("generated XML")
        end
      end

      describe "index_case got deleted or otherwise unavailable" do
        it "should redirect to index_case index if the index_case got deleted" do
          @index_case = create(:index_case, user: current_user)
          @index_case.destroy

          get :show, params: { id: @index_case.id }
          expect(response).to redirect_to(index_cases_path)
        end

        it "should return 404 (Not Found) JSON error" do
          @index_case = create(:index_case, user: current_user)
          @index_case.destroy
          request.env["HTTP_ACCEPT"] = "application/json"

          get :show, params: { id: @index_case.id }
          expect(response.code).to eq("404") # :not_found
        end

        it "should return 404 (Not Found) XML error" do
          @index_case = create(:index_case, user: current_user)
          @index_case.destroy
          request.env["HTTP_ACCEPT"] = "application/xml"

          get :show, params: { id: @index_case.id }
          expect(response.code).to eq("404") # :not_found
        end
      end
    end

    # GET /index_cases/new
    # GET /index_cases/new.xml                                                  AJAX
    #----------------------------------------------------------------------------
    describe "responding to GET new" do
      it "should expose a new index_case as @index_case and render [new] template" do
        @index_case = IndexCase.new(user: current_user,
                               access: Setting.default_access)
        get :new, xhr: true
        expect(assigns[:index_case].attributes).to eq(@index_case.attributes)
        expect(assigns[:contact]).to eq(nil)
        expect(response).to render_template("index_cases/new")
      end

      it "should created an instance of related object when necessary" do
        @contact = create(:contact, id: 42)

        get :new, params: { related: "contact_42" }, xhr: true
        expect(assigns[:contact]).to eq(@contact)
      end
    end

    # GET /index_cases/1/edit                                                   AJAX
    #----------------------------------------------------------------------------
    describe "responding to GET edit" do
      it "should expose the requested index_case as @index_case and render [edit] template" do
        @index_case = create(:index_case, id: 42, user: current_user)

        get :edit, params: { id: 42 }, xhr: true
        expect(assigns[:index_case]).to eq(@index_case)
        expect(assigns[:previous]).to eq(nil)
        expect(response).to render_template("index_cases/edit")
      end

      it "should expose previous index_case as @previous when necessary" do
        @index_case = create(:index_case, id: 42)
        @previous = create(:index_case, id: 41)

        get :edit, params: { id: 42, previous: 41 }, xhr: true
        expect(assigns[:previous]).to eq(@previous)
      end

      describe "(index_case got deleted or is otherwise unavailable)" do
        it "should reload current page if the index_case got deleted" do
          @index_case = create(:index_case, user: current_user)
          @index_case.destroy

          get :edit, params: { id: @index_case.id }, xhr: true
          expect(response.body).to eq("window.location.reload();")
        end
      end

      describe "(previous index_case got deleted or is otherwise unavailable)" do
        before do
          @index_case = create(:index_case, user: current_user)
          @previous = create(:index_case, user: create(:user))
        end

        it "should notify the view if previous index_case got deleted" do
          @previous.destroy

          get :edit, params: { id: @index_case.id, previous: @previous.id }, xhr: true
          expect(flash[:warning]).to eq(nil) # no warning, just silently remove the div
          expect(assigns[:previous]).to eq(@previous.id)
          expect(response).to render_template("index_cases/edit")
        end

        it "should notify the view if previous index_case got protected" do
          @previous.update_attribute(:access, "Private")

          get :edit, params: { id: @index_case.id, previous: @previous.id }, xhr: true
          expect(flash[:warning]).to eq(nil)
          expect(assigns[:previous]).to eq(@previous)
          expect(response).to render_template("index_cases/edit")
        end
      end
    end

    # POST /index_cases
    # POST /index_cases.xml                                                     AJAX
    #----------------------------------------------------------------------------
    describe "responding to POST create" do
      describe "with valid params" do
        it "should expose a newly created index_case as @index_case and render [create] template" do
          @index_case = build(:index_case, user: current_user)
          allow(IndexCase).to receive(:new).and_return(@index_case)
          post :create, params: @index_case.as_json, xhr: true
          expect(assigns(:index_case)).to eq(@index_case)
          expect(response).to render_template("index_cases/create")
        end

        # Note: [Create index_case] is shown only on index_cases index page.
        it "should reload index_cases to update pagination" do
          @index_case = build(:index_case, user: current_user)
          allow(IndexCase).to receive(:new).and_return(@index_case)

          post :create, params: @index_case.as_json, xhr: true
          expect(assigns[:index_cases]).to eq([@index_case])
        end

        it "should get data to update index_case sidebar" do
          @index_case = build(:index_case, user: current_user)
          allow(Campaign).to receive(:new).and_return(@index_case)

          post :create, params: @index_case.as_json, xhr: true
          expect(assigns[:index_case_category_total]).to be_instance_of(HashWithIndifferentAccess)
        end

        # it "should add a new comment to the newly created index_case when specified" do
        #   @index_case = build(:index_case, user: current_user)
        #   allow(IndexCase).to receive(:new).and_return(@index_case)

        #   post :create, params: { comment_body: "Awesome comment is awesome" }, xhr: true
        #   expect(assigns[:index_case].comments.map(&:comment)).to include("Awesome comment is awesome")
        # end
      end

      describe "with invalid params" do
        it "should expose a newly created but unsaved index_case as @index_case and still render [create] template" do
          @index_case = build(:index_case, user: nil)
          allow(IndexCase).to receive(:new).and_return(@index_case)

          post :create, params: { index_case: { invalid_param: 'invalid'} }, xhr: true
          expect(assigns(:index_case)).to eq(@index_case)
          expect(response).to render_template("index_cases/create")
        end
      end
    end

    # PUT /index_cases/1
    # PUT /index_cases/1.xml                                                    AJAX
    #----------------------------------------------------------------------------
    describe "responding to PUT update" do
      describe "with valid params" do
        it "should update the requested index_case, expose the requested index_case as @index_case, and render [update] template" do
          @index_case = create(:index_case, id: 42)

          put :update, params: { id: 42, index_case: { access: "Shared" } }, xhr: true
          expect(assigns(:index_case)).to eq(@index_case)
          expect(response).to render_template("index_cases/update")
        end

        it "should get data for index_cases sidebar when called from Campaigns index" do
          @index_case = create(:index_case, id: 42)
          request.env["HTTP_REFERER"] = "http://localhost/index_cases"

          put :update, params: { id: 42, index_case: { access: "Shared" } }, xhr: true
          expect(assigns(:index_case)).to eq(@index_case)
          expect(assigns[:index_case_category_total]).to be_instance_of(HashWithIndifferentAccess)
        end

        it "should update index_case permissions when sharing with specific users" do
          @index_case = create(:index_case, id: 42, access: "Public")

          put :update, params: { id: 42, index_case: { access: "Shared", user_ids: [7, 8] } }, xhr: true
          expect(assigns[:index_case].access).to eq("Shared")
          expect(assigns[:index_case].user_ids.sort).to eq([7, 8])
        end

        describe "index_case got deleted or otherwise unavailable" do
          it "should reload current page is the index_case got deleted" do
            @index_case = create(:index_case, user: current_user)
            @index_case.destroy

            put :update, params: { id: @index_case.id }, xhr: true
              expect(response.body).to eq("window.location.reload();")
          end
        end
      end
    end

    # DELETE /index_cases/1
    # DELETE /index_cases/1.xml
    #----------------------------------------------------------------------------
    describe "responding to DELETE destroy" do
      before do
        @index_case = create(:index_case, user: current_user)
      end

      describe "AJAX request" do
        it "should destroy the requested index_case and render [destroy] template" do
          @another_index_case = create(:index_case, user: current_user)
          delete :destroy, params: { id: @index_case.id }, xhr: true

          expect { IndexCase.find(@index_case.id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect(assigns[:index_cases]).to eq([@another_index_case]) # @index_case got deleted
          expect(response).to render_template("index_cases/destroy")
        end

        it "should get data for index_cases sidebar" do
          delete :destroy, params: { id: @index_case.id }, xhr: true

          expect(assigns[:index_case_category_total]).to be_instance_of(HashWithIndifferentAccess)
        end

        it "should try previous page and render index action if current page has no index_cases" do
          session[:index_cases_current_page] = 42

          delete :destroy, params: { id: @index_case.id }, xhr: true
          expect(session[:index_cases_current_page]).to eq(41)
          expect(response).to render_template("index_cases/index")
        end

        it "should render index action when deleting last index_case" do
          session[:index_cases_current_page] = 1

          delete :destroy, params: { id: @index_case.id }, xhr: true
          expect(session[:index_cases_current_page]).to eq(1)
          expect(response).to render_template("index_cases/index")
        end

        describe "index_case got deleted or otherwise unavailable" do
          it "should reload current page is the index_case got deleted" do
            @index_case = create(:index_case, user: current_user)
            @index_case.destroy

            delete :destroy, params: { id: @index_case.id }, xhr: true
              expect(response.body).to eq("window.location.reload();")
          end
        end
      end

      describe "HTML request" do
        it "should redirect to index_case index if the index_case got deleted" do
          @contact = create(:contact, first_name: "Contact Name")
          @index_case = create(:index_case, user: current_user, contact: @contact)
          @index_case.destroy

          delete :destroy, params: { id: @index_case.id }
          expect(response).to redirect_to(index_cases_path)
        end
      end
    end

    # PUT /index_cases/1/attach
    # PUT /index_cases/1/attach.xml                                             AJAX
    #----------------------------------------------------------------------------
    describe "responding to PUT attach" do
      describe "tasks" do
        before do
          @model = create(:index_case)
          @attachment = create(:task, asset: nil)
        end
        it_should_behave_like("attach")
      end
    end

    # POST /index_cases/1/discard
    # POST /index_cases/1/discard.xml                                           AJAX
    #----------------------------------------------------------------------------
    describe "responding to POST discard" do
      describe "tasks" do
        before do
          @model = create(:index_case)
          @attachment = create(:task, asset: @model)
        end
        it_should_behave_like("discard")
      end
    end

    # POST /index_cases/auto_complete/query                                     AJAX
    #----------------------------------------------------------------------------
    describe "responding to POST auto_complete" do
      before do
        @auto_complete_matches = [create(:index_case, user: current_user)]
      end

      it_should_behave_like("auto complete")
    end

    describe "UPDATE action" do
      let(:index_case) { create(:index_case, user: current_user, access: "Public") }
      let(:contact) { create(:contact, user: current_user, access: "Public") }
      it 'creates absences for exposed people' do
        put :update, params: { id: index_case.id, index_case: { exposures_attributes: { 0 => { started_at: 3.days.ago, ended_at: 1.day.ago, contact_id: contact.id} } } }, xhr: true
        expect(contact.reload.absences).to_not be_empty
      end
    end
  end
end
