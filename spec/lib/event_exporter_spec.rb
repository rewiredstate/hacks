require "spec_helper"
require "event_exporter"

describe "exporting an event" do
  before do
    @event = FactoryGirl.create(:event,
      :title => "Event One",
      :slug => "event-one",
      :hashtag => "event",
      :secret => "secret111",
      :active => true,
      :use_centres => true,
      :url => "http://foo.com",
      :enable_project_creation => true,
      :start_date => Date.parse("1 January 2013")
    )
    @award1 = FactoryGirl.create(:award_category,
      :title => "The Best Around",
      :description => "Nothing's gonna ever bring it down",
      :format => "overall",
      :level => 1,
      :featured => true,
      :event => @event
    )
    @award2 = FactoryGirl.create(:award_category,
      :title => "Stars In Your Eyes season trophy",
      :description => "And tonight, Matthew, I'm going to be",
      :format => "mention",
      :level => 2,
      :featured => false,
      :event => @event
    )
    @centre1 = FactoryGirl.create(:centre,
      :name => "Mordor",
      :slug => "mordor",
      :event => @event
    )
    @centre2 = FactoryGirl.create(:centre,
      :name => "Oz",
      :slug => "oz",
      :event => @event
    )

    project1 = FactoryGirl.create(:project,
      :title => "A Project",
      :slug => "a-project",
      :team => "Lots of people",
      :description => "Description of the hack",
      :summary => "Summary of the hack",
      :url => "http://example.com/",
      :twitter => "@twitter",
      :github_url => "https://github.com/github/github",
      :event => @event,
      # send the event password so it will allow creation
      :my_secret => "secret111",
      :secret => nil,
      :centre => @centre1
    )
    project2 = FactoryGirl.create(:project,
      :title => "A Winning Project",
      :slug => "a-winning-project",
      :event => @event,
      # send the event password so it will allow creation
      :my_secret => "secret111",
      :secret => nil,
      :centre => @centre2
    )
    @award1.award_to(project2)
    @award2.award_to(project2)

    @exporter = EventExporter.new(@event)
  end

  it "renders the event as json" do
    json = JSON.parse @exporter.to_json

    json["title"].should == "Event One"
    json["slug"].should == "event-one"
    json["hashtag"].should == "event"
    json["secret"].should == "secret111"
    json["use_centres"].should == true
    json["active"].should == true
    json["url"].should == "http://foo.com"
    json["enable_project_creation"].should == true
    json["start_date"].should == "2013-01-01"
  end

  it "includes any award categories" do
    json = JSON.parse @exporter.to_json

    json["award_categories"].size.should == 2

    json["award_categories"][0]["title"].should == "The Best Around"
    json["award_categories"][1]["title"].should == "Stars In Your Eyes season trophy"

    json["award_categories"][0]["description"].should == "Nothing's gonna ever bring it down"
    json["award_categories"][1]["description"].should == "And tonight, Matthew, I'm going to be"

    json["award_categories"][0]["format"].should == "overall"
    json["award_categories"][1]["format"].should == "mention"

    json["award_categories"][0]["level"].should == "1"
    json["award_categories"][1]["level"].should == "2"

    json["award_categories"][0]["featured"].should == true
    json["award_categories"][1]["featured"].should == false
  end

  it "includes all projects with awards" do
    json = JSON.parse @exporter.to_json

    json["projects"].size.should == 2

    json["projects"][0]["title"].should == "A Project"
    json["projects"][0]["slug"].should == "a-project"
    json["projects"][0]["team"].should == "Lots of people"
    json["projects"][0]["description"].should == "Description of the hack"
    json["projects"][0]["summary"].should == "Summary of the hack"
    json["projects"][0]["url"].should == "http://example.com/"
    json["projects"][0]["twitter"].should == "@twitter"
    json["projects"][0]["github_url"].should == "https://github.com/github/github"
    json["projects"][0]["image_file_name"].should == "image.jpg"

    json["projects"][1]["title"] == "A Winning Project"

    json["projects"][1]["awards"].size.should == 2
    json["projects"][1]["awards"][0]["award_category_id"].should == @award1.id
    json["projects"][1]["awards"][1]["award_category_id"].should == @award2.id
  end

  it "includes all the centres" do
    json = JSON.parse @exporter.to_json

    json["centres"].size.should == 2

    json["centres"][0]["name"].should == "Mordor"
    json["centres"][1]["name"].should == "Oz"

    json["centres"][0]["slug"].should == "mordor"
    json["centres"][1]["slug"].should == "oz"

    json["centres"][0]["id"].should == @centre1.id
    json["centres"][1]["id"].should == @centre2.id
  end
end
