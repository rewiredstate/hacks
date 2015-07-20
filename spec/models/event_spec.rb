require 'rails_helper'

RSpec.describe Event, type: :model do

  describe "creating an event" do
    let(:valid_attributes) {
      {
        title: "Event Title",
        slug: "event-slug",
        secret: "secret",
        start_date: Date.parse("1 January 2013"),
      }
    }

    context "given valid attributes" do
      it "can create an event" do
        Event.create!(valid_attributes)
      end

      it "can set a slug if none exists" do
        event = Event.create!( valid_attributes.merge({:slug => nil}) )

        expect(event.slug).to eq("event-title")
      end

      it "doesn't generate a slug if one is present" do
        event = Event.create!( valid_attributes )

        expect(event.slug).to eq("event-slug")
      end

      it "can generate a unique slug where an event with the same title exists" do
        event_one = Event.create!( valid_attributes.merge({:slug => nil}) )
        event_two = Event.create!( valid_attributes.merge({:slug => nil}) )

        expect(event_one.slug).to eq("event-title")
        expect(event_two.slug).to eq("event-title-2")
      end

      it "does not have a password if the secret is blank" do
        event = Event.create!(valid_attributes.merge({:secret => ''}))

        expect(event).to_not have_secret
      end

      it "does not use centres by default" do
        event = Event.create!( valid_attributes )

        expect(event.use_centres).to eq(false)
      end

      it "can be created as an event with centres" do
        event = Event.create!( valid_attributes.merge({:use_centres => true}) )

        expect(event.use_centres).to eq(true)
      end
    end

    context "given invalid attributes" do
      it "can't create an event with an empty title" do
        event = Event.new(valid_attributes.merge({:title => ''}))

        expect(event).to_not be_valid
      end
    end
  end

  describe "creating award categories for event" do
    let(:event) { FactoryGirl.create(:event) }
    let(:award_category_atts) {
      {
        title: 'Best in Show',
        description: 'The best hack',
        level: '1',
        format: 'overall',
        featured: true,
      }
    }

    it "can accept attributes for an award category" do
      event.update_attributes!({ :award_categories_attributes => [ award_category_atts ] })

      expect(event.award_categories).to_not be_empty
      expect(event.award_categories.first.title).to eq("Best in Show")
    end

    it "can remove an award category" do
      award_category = event.award_categories.create!(award_category_atts)

      event.update_attributes!(
        award_categories_attributes: [
          { :id => award_category.id, :'_destroy' => '1' }
        ]
      )

      expect(event.award_categories.count).to eq(0)
    end

    context "given projects which have won awards" do
      let(:project_one) { FactoryGirl.create(:project, event: event) }
      let(:project_two) { FactoryGirl.create(:project, event: event) }

      let(:featured_award_category) { event.award_categories.create!(award_category_atts) }
      let(:other_award_category) { event.award_categories.create!(award_category_atts.merge(featured: false)) }

      it "should only return featured award categories as winners" do
        featured_award_category.award_to(project_one)
        other_award_category.award_to(project_two)

        expect(event.winners.count).to eq(1)
        expect(event.winners).to contain_exactly(project_one)

        expect(event.award_winners.count).to eq(2)
        expect(event.award_winners).to contain_exactly(project_one, project_two)
      end
    end
  end

  describe "creating centres for events" do
    let(:event) { FactoryGirl.create(:event) }
    let(:centre_atts) {
      {
        name: 'Manchester',
        slug: 'manchester',
      }
    }

    it "can accept attributes for a centre" do
      event.update_attributes!({ :centres_attributes => [ centre_atts ] })

      expect(event.centres).to_not be_empty
      expect(event.centres.first.name).to eq("Manchester")
    end

    it "cannot remove a centre" do
      centre = event.centres.create!(centre_atts)

      event.update_attributes!(centres_attributes: [
        { :id => centre.id, :'_destroy' => '1' }
      ])
      expect(event.centres.count).to eq(1)
    end
  end

end
