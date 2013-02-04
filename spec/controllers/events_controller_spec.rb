require 'spec_helper'

describe EventsController do
  describe "GET index" do
    before do
      @events = [
        FactoryGirl.create(:event, :title => "Event One", :start_date => Date.parse("1 January 2013")),
        FactoryGirl.create(:event, :title => "Event Two", :start_date => Date.parse("3 January 2013")),
        FactoryGirl.create(:event, :title => "Event Three", :start_date => Date.parse("2 January 2013"))
      ]
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "assigns a collection of all the events" do
      get :index
      assigns(:events).should =~ @events
    end

    it "loads the most recent events first" do
      get :index

      assigns(:events).map(&:title).should == ["Event Two", "Event Three", "Event One"]
    end
  end

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
