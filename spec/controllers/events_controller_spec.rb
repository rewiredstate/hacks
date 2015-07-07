require 'rails_helper'

describe EventsController do
  describe "GET index" do
    let!(:events) {
      [
        create(:event, title: "Event One", start_date: Date.parse('1 January 2013')),
        create(:event, title: "Event Two", start_date: Date.parse('3 January 2013')),
        create(:event, title: "Event Three", start_date: Date.parse('2 January 2013')),
      ]
    }

    it "should be successful" do
      get :index

      expect(response).to be_success
    end

    it "assigns a collection of all the events" do
      get :index

      expect(controller.events).to contain_exactly(*events)
    end

    it "loads the most recent events first" do
      get :index

      expect(controller.events.map(&:title)).to eq(["Event Two", "Event Three", "Event One"])
    end
  end

  context "given an event exists" do
    let(:event) { create(:event) }

    describe "GET show" do
      it "should be successful" do
        get :show, id: event

        expect(response).to be_success
      end

      it "can assign the event details" do
        get :show, id: event

        expect(controller.event).to eq(event)
      end

      it "can assign a collection of all the projects" do
        project_one = create(:project, event: event)
        project_two = create(:project, event: event)

        get :show, id: event

        expect(assigns(:event).projects).to contain_exactly(project_one, project_two)
      end
    end
  end
end
