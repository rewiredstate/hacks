require 'spec_helper'

describe Admin::ProjectsController do

  before do
    @event = FactoryGirl.create(:event_without_secret)
  end

  context "when not signed in" do
    describe "GET 'index'" do
      it "should redirect to the login form" do
        get :index, :event_id => @event.id
        response.should be_redirect
      end
    end
  end

  context "when signed in" do
    login_admin

    describe "GET index" do
      it "should be successful" do
        get :index, :event_id => @event.slug
        response.should be_success
      end

      it "can assign a collection of all the projects" do
        @project_one = FactoryGirl.create(:project_with_secret, :event => @event)
        @project_two = FactoryGirl.create(:project_with_secret, :event => @event)

        get :index, :event_id => @event.slug
        assigns(:projects).should =~ [@project_one, @project_two]
      end
    end

    describe "PUT update" do
      before do
        @project = FactoryGirl.create(:project_with_secret, :event => @event)
      end

      context "given valid attributes" do
        before do
          @valid_attributes = {
            :title => "Alt Project Title",
            :team => "Team Name"
          }
        end

        it "should update the project" do
          put :update, :event_id => @event.slug, :id => @project.slug, :project => @valid_attributes
          assigns(:project).title.should == "Alt Project Title"
          assigns(:project).team.should == "Team Name"
        end

        it "should redirect to the project list" do
          put :update, :event_id => @event.slug, :id => @project.slug, :project => @valid_attributes
          response.should be_redirect
        end
      end

      context "given invalid attributes" do
        before do
          @invalid_attributes = {
            :title => ""
          }
        end

        it "should render the edit form" do
          put :update, :event_id => @event.slug, :id => @project.slug, :project => @invalid_attributes
          response.should render_template(:edit)
        end
      end
    end
  end

end