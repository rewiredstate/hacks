require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:event) { FactoryGirl.create(:event_without_secret) }

  describe "POST create" do
    context "given valid attributes" do
      let(:attributes) { attributes_for(:project_with_secret) }

      it "should create the project" do
        expect {
          post :create, :event_id => event.slug, :project => attributes
        }.to change {
          Project.count
        }.by(1)

        expect(assigns(:project)).to be_persisted
        expect(assigns(:project).title).to eq(attributes[:title])
      end

      it "should redirect to the project" do
        post :create, :event_id => event.slug, :project => attributes

        expect(response).to redirect_to(
                              event_project_path(event, assigns(:project))
                            )
      end
    end

    context "given invalid attributes" do
      let(:invalid_attributes) {
        { title: "" }
      }

      it "should render the new form" do
        post :create, :event_id => event.slug, :project => invalid_attributes

        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT update" do
    let(:project) {
      FactoryGirl.create(:project, :event => event, :secret => 'secret')
    }

    context "given valid attributes" do
      let(:valid_attributes) {
        {
          title: "Modified Project Title",
          team: "Ian and Mark",
          my_secret: "secret",
        }
      }

      it "should create the project" do
        put :update, :id => project.slug, :event_id => event.slug, :project => valid_attributes

        expect(assigns(:project).title).to eq("Modified Project Title")
        expect(assigns(:project).team).to eq("Ian and Mark")
      end

      it "should redirect to the project" do
        post :update, :id => project.slug, :event_id => event.slug, :project => valid_attributes

        expect(response).to redirect_to(event_project_path(event, project))
      end
    end

    context "given invalid attributes" do
      let(:invalid_attributes) {
        {
          title: ""
        }
      }

      it "should render the new form" do
        put :update, :id => project.slug, :event_id => event.slug, :project => invalid_attributes

        expect(response).to render_template(:edit)
      end
    end
  end

end
