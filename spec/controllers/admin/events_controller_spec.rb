require 'rails_helper'

RSpec.describe Admin::EventsController do

  context "when not signed in" do
    describe "GET 'index'" do
      it "should redirect to the login form" do
        get :index
        expect(response).to be_redirect
      end
    end
  end

  context "when signed in" do
    before(:each) {
      sign_in_admin
    }

    describe "GET index" do
      it "should be successful" do
        get :index
        expect(response).to be_success
      end

      it "can assign a collection of all the events" do
        @event_one = FactoryGirl.create(:event)
        @event_two = FactoryGirl.create(:event)

        get :index
        expect(controller.events).to contain_exactly(@event_one, @event_two)
      end
    end

    describe "POST create" do
      context "given valid attributes" do
        let(:attributes) { attributes_for(:event) }

        it "should create the event" do
          post :create, :event => attributes

          expect(controller.event).to be_persisted
          expect(controller.event.title).to eq(attributes[:title])
        end

        it "should redirect to the event list" do
          post :create, :event => attributes

          expect(response).to redirect_to(admin_events_path)
        end
      end

      context "given invalid attributes" do
        it "should render the form" do
          post :create, :event => { }
          expect(response).to render_template(:new)
        end
      end
    end
  end

end
