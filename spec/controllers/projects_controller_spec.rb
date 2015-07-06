require 'rails_helper'

RSpec.describe ProjectsController do

  before do
    @event = FactoryGirl.create(:event_without_secret)
  end

  describe "POST create" do
    context "given valid attributes" do
      before do
        @valid_attributes = {
          :title => "Project One",
          :team => "Roland and Michael",
          :description => "The ultimate hack. Every hack you've ever dreamed of in one. Defining an entire genre of hacks.",
          :summary => "A shorter summary of how awesome this project is",
          :url => "http://example.project.com/",
          :twitter => "@rewiredstate",
          :github_url => "http://github.com/rewiredstate/hacks",
          :image => stub_uploaded_file,
          :secret => "secret"
        }
      end

      it "should create the project" do
        post :create, :event_id => @event.slug, :project => @valid_attributes
        assigns(:project).title.should == "Project One"
        assigns(:project).team.should == "Roland and Michael"
      end

      it "should redirect to the project" do
        post :create, :event_id => @event.slug, :project => @valid_attributes
        response.should redirect_to(event_project_path(@event,"project-one"))
      end
    end

    context "given invalid attributes" do
      before do
        @invalid_attributes = {
          :title => ""
        }
      end

      it "should render the new form" do
        post :create, :event_id => @event.slug, :project => @invalid_attributes
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
    before do
      @project = FactoryGirl.create(:project, :event => @event, :secret => 'secret')
    end

    context "given valid attributes" do
      before do
        @valid_attributes = {
          :title => "Modified Project Title",
          :team => "Ian and Mark",
          :my_secret => "secret"
        }
      end

      it "should create the project" do
        put :update, :id => @project.slug, :event_id => @event.slug, :project => @valid_attributes
        assigns(:project).title.should == "Modified Project Title"
        assigns(:project).team.should == "Ian and Mark"
      end

      it "should redirect to the project" do
        post :update, :id => @project.slug, :event_id => @event.slug, :project => @valid_attributes
        response.should redirect_to(event_project_path(@event, @project))
      end
    end

    context "given invalid attributes" do
      before do
        @invalid_attributes = {
          :title => ""
        }
      end

      it "should render the new form" do
        put :update, :id => @project.slug, :event_id => @event.slug, :project => @invalid_attributes
        response.should render_template(:edit)
      end
    end
  end

end
