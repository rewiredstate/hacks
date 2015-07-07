require 'rails_helper'

RSpec.describe Admin::ProjectsController do
  let(:event) { FactoryGirl.create(:event_without_secret) }

  context "when not signed in" do
    describe "GET 'index'" do
      it "should redirect to the login form" do
        get :index, :event_id => event.id

        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  context "when signed in" do
    before(:each) {
      sign_in_admin
    }

    describe "GET index" do
      it "should be successful" do
        get :index, :event_id => event.slug

        expect(response).to be_success
      end

      it "can assign a collection of all the projects" do
        project_one = create(:project_with_secret, :event => event)
        project_two = create(:project_with_secret, :event => event)

        get :index, :event_id => event.slug
        expect(controller.projects).to contain_exactly(project_one, project_two)
      end
    end

    describe "PUT update" do
      let(:project) { create(:project_with_secret, :event => event) }

      context "given valid attributes" do
        let(:valid_attributes) {
          {
            title: "Alt Project Title",
            team: "Team Name",
          }
        }

        it "should update the project" do
          put :update, :event_id => event.slug, :id => project.slug, :project => valid_attributes

          expect(controller.project.title).to eq("Alt Project Title")
          expect(controller.project.team).to eq("Team Name")
        end

        it "should redirect to the project list" do
          put :update, :event_id => event.slug, :id => project.slug, :project => valid_attributes

          expect(response).to redirect_to(admin_event_projects_path(event))
        end
      end

      context "given invalid attributes" do
        let(:invalid_attributes) {
          {
            title: ""
          }
        }

        it "should render the edit form" do
          put :update, event_id: event.slug,
                       id: project.slug,
                       project: invalid_attributes

          expect(response).to render_template(:edit)
        end
      end
    end
  end

end
