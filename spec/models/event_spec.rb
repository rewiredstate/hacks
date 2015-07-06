require 'rails_helper'

RSpec.describe Event do

  describe "creating an event" do
    before do
      @valid_attributes = {
        :title => "Event Title",
        :slug => "event-slug",
        :secret => "secret",
        :start_date => Date.parse("1 January 2013")
      }
    end

    context "given valid attributes" do
      it "can create an event" do
        Event.create!(@valid_attributes)
      end

      it "can set a slug if none exists" do
        @event = Event.create!( @valid_attributes.merge({:slug => nil}) )
        @event.slug.should == "event-title"
      end

      it "doesn't generate a slug if one is present" do
        @event = Event.create!( @valid_attributes )
        @event.slug.should == "event-slug"
      end

      it "can generate a unique slug where an event with the same title exists" do
        @event_one = Event.create!( @valid_attributes.merge({:slug => nil}) )
        @event_two = Event.create!( @valid_attributes.merge({:slug => nil}) )

        @event_one.slug.should == "event-title"
        @event_two.slug.should == "event-title-2"
      end

      it "does not have a password if the secret is blank" do
        @event = Event.create!(@valid_attributes.merge({:secret => ''}))
        @event.should_not have_secret
      end

      it "does not use centres by default" do
        @event = Event.create!( @valid_attributes )
        @event.use_centres.should be_false
      end

      it "can be created as an event with centres" do
        @event = Event.create!( @valid_attributes.merge({:use_centres => true}) )
        @event.use_centres.should be_true
      end
    end

    context "given invalid attributes" do
      it "can't create an event with an empty title" do
        @event = Event.new @valid_attributes.merge({:title => ''})
        @event.should_not be_valid
      end
    end
  end

  describe "creating award categories for event" do
    before do
      @event = FactoryGirl.create(:event)
      @award_category_atts = {
        :title => 'Best in Show',
        :description => 'The best hack',
        :level => '1',
        :format => 'overall',
        :featured => true
      }
    end

    it "can accept attributes for an award category" do
      @event.update_attributes!({ :award_categories_attributes => [ @award_category_atts ] })

      @event.award_categories.should be_any
      @event.award_categories.first.title.should == "Best in Show"
    end

    it "can remove an award category" do
      @award_category = @event.award_categories.create!(@award_category_atts)

      @event.update_attributes!({ :award_categories_attributes => [{ :id => @award_category.id, :'_destroy' => '1' }] })
      @event.award_categories.count.should == 0
    end

    context "given projects which have won awards" do

      it "should only return featured award categories as winners" do
        @featured_award_category = @event.award_categories.create!(@award_category_atts)
        @other_award_category = @event.award_categories.create!(@award_category_atts.merge({:featured => false}))

        @project_one = FactoryGirl.create(:project_with_event_secret)
        @project_two = FactoryGirl.create(:project_with_event_secret)
        @project_one.update_attribute(:event_id, @event.id)
        @project_two.update_attribute(:event_id, @event.id)

        @featured_award_category.award_to(@project_one)
        @other_award_category.award_to(@project_two)

        @event.winners.count.should == 1
        @event.winners.should =~ [ @project_one ]

        @event.award_winners.count.should == 2
        @event.award_winners.should =~ [ @project_one, @project_two ]
      end
    end
  end

  describe "creating centres for events" do
    before do
      @event = FactoryGirl.create(:event)
      @centre_atts = {
        :name => 'Manchester',
        :slug => 'manchester'
      }
    end

    it "can accept attributes for a centre" do
      @event.update_attributes!({ :centres_attributes => [ @centre_atts ] })

      @event.centres.should be_any
      @event.centres.first.name.should == "Manchester"
    end

    it "cannot remove a centre" do
      @centre = @event.centres.create!(@centre_atts)

      @event.update_attributes!({ :centres_attributes => [{ :id => @centre.id, :'_destroy' => '1' }] })
      @event.centres.count.should == 1
    end
  end

end
