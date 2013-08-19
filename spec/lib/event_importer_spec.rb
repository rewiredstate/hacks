require "spec_helper"
require "event_importer"

describe "importing an event" do
  it "fails if the file does not exist" do
    expect {
      EventImporter.new( Rails.root.join("spec","fixtures","blah.json") )
    }.to raise_error(EventImporter::FileNotFound)
  end

  context "given a valid file" do
    before do
      @importer = EventImporter.new( Rails.root.join("spec","fixtures","event.json") )
    end

    it "fails if an event with an identical slug already exists" do
      FactoryGirl.create(:event, :slug => "event")

      expect { @importer.run }.to raise_error(EventImporter::DuplicateSlug)
    end

    it "creates the event from the given attributes" do
      @importer.run

      event = Event.find_by_slug("event")
      event.should be_present

      event.title.should == "Event"
      event.slug.should == "event"
      event.url.should == "http://www.test.com/"
      event.hashtag.should == "foo"
      event.start_date.should == Date.parse("2013-08-01")
      event.secret.should == "secret"

      event.active.should be_true
      event.enable_project_creation.should be_true
      event.use_centres.should be_true
    end

    it "creates all award categories for the event" do
      @importer.run

      event = Event.find_by_slug("event")
      event.should be_present

      event.award_categories.count.should == 3
      event.award_categories.map(&:title).should        == ["Best in Show", "Special Mention", "Finalist"]
      event.award_categories.map(&:description).should  == ["Best hack created during the event", "Noted by the judges for their effort or technical achievent", "Centre winner"]
      event.award_categories.map(&:format).should       == ["overall", "mention", "finalist"]
      event.award_categories.map(&:featured).should     == [true, true, false]
      event.award_categories.map(&:level).should        == ["1", "2", "2"]
    end

    it "creates all centres for the event" do
      @importer.run

      event = Event.find_by_slug("event")
      event.should be_present

      event.centres.count.should == 3
      event.centres.map(&:name).should == ["Gondor", "Mordor", "The Shire"]
      event.centres.map(&:slug).should == ["gondor", "mordor", "the-shire"]
    end

    it "creates all projects for the event" do
      @importer.run

      event = Event.find_by_slug("event")
      event.should be_present

      event.projects.count.should == 3
      event.projects.map(&:title).should       == ["Hack-o-matic", "Hackr", "Insta-hack"]
      event.projects.map(&:slug).should        == ["hack-o-matic", "hackr", "insta-hack"]
      event.projects.map(&:description).should == ["Foo", "Bar", "Baz"]
      event.projects.map(&:summary).should     == ["Foo", "Bar", "Baz"]
      event.projects.map(&:team).should        == ["Somebody", "Somebody Else", "Somebody Else (again)"]
      event.projects.map(&:twitter).should     == ["@test", "@test", "@test"]
      event.projects.map(&:secret).should      == [nil, nil, nil]

      event.projects.map(&:centre).map(&:slug).should == ["gondor", "gondor", "mordor"]
      event.projects.map {|p| p.awards.map {|a| a.award_category.title } }.should == [["Special Mention"], ["Best in Show"], ["Finalist"]]
    end
  end

  context "given an event with project creation disabled" do
    before do
      @importer = EventImporter.new( Rails.root.join("spec","fixtures","event-two.json") )
    end

    it "sets the attribute correctly on the event" do
      @importer.run

      event = Event.find_by_slug("event-two")
      event.should be_present

      event.enable_project_creation.should be_false
    end

    it "can recreate the existing projects" do
      @importer.run

      event = Event.find_by_slug("event-two")
      event.should be_present

      event.projects.count.should == 3
    end
  end
end
