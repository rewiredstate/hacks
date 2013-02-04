require 'spec_helper'

describe Admin::EventsController do

  context "when not signed in" do
    describe "GET 'index'" do
      it "should redirect to the login form" do
        get :index
        response.should be_redirect
      end
    end
  end

  context "when signed in" do
    login_admin

    describe "GET index" do
      it "should be successful" do
        get :index
        response.should be_success
      end

      it "can assign a collection of all the events" do
        @event_one = FactoryGirl.create(:event)
        @event_two = FactoryGirl.create(:event)

        get :index
        assigns(:events).should =~ [@event_one, @event_two]
      end
    end

    describe "POST create" do
      context "given valid attributes" do
        before do
          @valid_attributes = {
            :title => "Example Event",
            :secret => nil,
            :start_date => "1 January 2013",
            :award_categories_attributes => [
              { :title => "Best in Show", :format => "overall", :level => "1" }
            ]
          }
        end

        it "should create the event" do
          post :create, :event => @valid_attributes
          assigns(:event).should be_persisted
          assigns(:event).title.should == "Example Event"
          assigns(:event).start_date.should == Date.parse("1 January 2013")
        end

        it "should redirect to the event list" do
          post :create, :event => @valid_attributes
          response.should redirect_to(admin_events_path)
        end
      end

      context "given invalid attributes" do
        it "should render the form" do
          post :create, :event => { }
          response.should render_template(:new)
        end
      end
    end
  end

end
