require 'spec_helper'

describe EventsController do
  context "given an event exists" do
    before do
      @event = FactoryGirl.create(:event_without_secret)
    end

    describe "GET show" do
      it "should be successful" do
        get :show, :id => @event.slug
        response.should be_success
      end

      it "can assign the event details" do
        get :show, :id => @event.slug
        assigns(:event).should == @event
      end

      it "can assign a collection of all the projects" do
        @project_one = FactoryGirl.create(:project_with_secret, :event => @event)
        @project_two = FactoryGirl.create(:project_with_secret, :event => @event)

        get :show, :id => @event.slug
        assigns(:event).projects.should =~ [@project_one, @project_two]
      end
    end
  end
end