require 'spec_helper'

describe Project do

  describe "creating an project" do
    before do
      @valid_attributes = {
        :title => "Project One",
        :team => "Roland and Michael",
        :description => "The ultimate hack. Every hack you've ever dreamed of in one. Defining an entire genre of hacks.",
        :summary => "A shorter summary of how awesome this project is",
        :url => "http://example.project.com/",
        :twitter => "@rewiredstate",
        :github_url => "http://github.com/rewiredstate/hacks",
        :image => stub_uploaded_image
      }
    end

    describe "where the event has a password" do
      before do
        @event = FactoryGirl.create(:event, :secret => "secret")
        @valid_attributes.merge!({ :my_secret => @event.secret })
      end

      describe "given valid attributes" do
        it "can be created" do
          @project = @event.projects.create!(@valid_attributes)
          @project.should be_persisted
        end

        it "sets the slug based on the title" do
          @project = @event.projects.create!(@valid_attributes)
          @project.slug.should == "project-one"
        end

        describe "the created project" do
          it "has not won awards" do
            @project = @event.projects.create!(@valid_attributes)
            @project.should_not have_won_award
          end
        end
      end

      describe "given invalid attributes" do
        it "can't be created with the wrong event password" do
          @valid_attributes.merge!({ :my_secret => "not the event secret" })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created if the event no longer allows new projects to be created" do
          @event = FactoryGirl.create(:event, :enable_project_creation => false)
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created without a screenshot" do
          @valid_attributes.merge!({ :image => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created without a title" do
          @valid_attributes.merge!({ :title => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created without a team name" do
          @valid_attributes.merge!({ :team => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created without a summary" do
          @valid_attributes.merge!({ :summary => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created with a summary longer than 180 characters" do
          @valid_attributes.merge!({ :summary => "test".ljust(181) })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created without a description" do
          @valid_attributes.merge!({ :description => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created with an invalid url" do
          @valid_attributes.merge!({ :url => "this does not look like a valid url" })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created with an invalid image" do
          @valid_attributes.merge!({ :image => stub_uploaded_image("invalid_image_file") })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end

        it "can't be created with a duplicate slug for the same event" do
          @project_one = @event.projects.build(@valid_attributes)
          @project_one.slug = "project-slug"
          @project_one.save!

          @project_two = @event.projects.build(@valid_attributes)
          @project_two.slug = "project-slug"
          @project_two.should_not be_valid
          @project_two.should have(1).error_on(:slug)
        end
      end
    end

    describe "where the event does not have a password" do
      before do
        @event = FactoryGirl.create(:event, :secret => nil)
        @valid_attributes.merge!({ :secret => "secret" })
      end

      describe "given valid attributes" do
        it "can be created" do
          @project = @event.projects.create!(@valid_attributes)
          @project.should be_persisted
        end
      end

      describe "given invalid attributes" do
        it "can't be created with an empty project password" do
          @valid_attributes.merge!({ :secret => nil })
          @project = @event.projects.build(@valid_attributes)
          @project.should_not be_valid
        end
      end
    end

    describe "where the event has centres" do
      before do
        @event = FactoryGirl.create(:event, :secret => "secret", :use_centres => true)
        @centre = @event.centres.create!(:name => "London", :slug => "london")
        @valid_attributes.merge!({ :my_secret => @event.secret, :centre => @centre })
      end

      describe "given valid attributes" do
        it "can be created" do
          @project = @event.projects.create!(@valid_attributes)
          @project.should be_persisted
        end
      end

      describe "given invalid attributes" do
        it "can't be created without a centre" do
          @invalid_attributes = @valid_attributes.merge({ :centre => nil })
          @project = @event.projects.build(@invalid_attributes)
          @project.should_not be_valid
        end
      end
    end
  end

  describe "updating a project" do
    before do
      @valid_attributes = {
        :title => "Updated Title",
        :summary => "An updated summary",
        :image => stub_uploaded_image('alternative.jpg')
      }
    end

    describe "as a user" do
      describe "where the event does not have a password" do
        before do
          @project = FactoryGirl.create(:project_with_secret)
        end

        describe "given valid attributes" do
          before do
            @valid_attributes.merge!({ :my_secret => @project.secret })
          end

          it "can be updated" do
            @project.update_attributes!(@valid_attributes)
            @project.title.should == @valid_attributes[:title]
            @project.summary.should == @valid_attributes[:summary]
            @project.image.url.should =~ /alternative\.jpg/
          end
        end

        describe "given invalid attributes" do
          it "can not update a project with an empty project password" do
            @valid_attributes.merge!({ :my_secret => nil })
            @project.update_attributes(@valid_attributes).should be_false
          end

          it "can not update a project with an invalid project password" do
            @valid_attributes.merge!({ :my_secret => "not the correct project password" })
            @project.update_attributes(@valid_attributes).should be_false
          end
        end
      end

      describe "where the event has a password" do
        before do
          @project = FactoryGirl.create(:project_with_event_secret)
        end

        describe "given valid attributes" do
          before do
            @valid_attributes.merge!({ :my_secret => @project.event.secret })
          end

          it "can be updated" do
            @project.update_attributes!(@valid_attributes)
            @project.title.should == @valid_attributes[:title]
            @project.summary.should == @valid_attributes[:summary]
            @project.image.url.should =~ /alternative\.jpg/
          end
        end

        describe "given invalid attributes" do
          it "can not update a project with an empty event password" do
            @valid_attributes.merge!({ :my_secret => nil })
            @project.update_attributes(@valid_attributes).should be_false
          end

          it "can not update a project with an invalid event password" do
            @valid_attributes.merge!({ :my_secret => "not the correct event password" })
            @project.update_attributes(@valid_attributes).should be_false
          end
        end
      end
    end

    describe "as an admin" do
      describe "updating a project" do
        describe "where the event has a password" do
          before do
            @project = FactoryGirl.create(:project_with_event_secret)
            @project.managing = true
          end

          it "can update a project without the password" do
            @valid_attributes.merge!({ :my_secret => nil })

            @project.update_attributes!(@valid_attributes)
            @project.title.should == @valid_attributes[:title]
            @project.summary.should == @valid_attributes[:summary]
            @project.image.url.should =~ /alternative\.jpg/
          end
        end

        describe "where the event does not have a password" do
          before do
            @project = FactoryGirl.create(:project_with_secret)
            @project.managing = true
          end

          it "can update a project without the password" do
            @valid_attributes.merge!({ :my_secret => nil })

            @project.update_attributes!(@valid_attributes)
            @project.title.should == @valid_attributes[:title]
            @project.summary.should == @valid_attributes[:summary]
            @project.image.url.should =~ /alternative\.jpg/
          end
        end

        describe "giving awards to a project" do
          before do
            @event = FactoryGirl.create(:event_without_secret)
            @award_category = FactoryGirl.create(:award_category, :event => @event)

            @project = FactoryGirl.create(:project_with_secret, :event => @event)
            @project.managing = true
          end

          it "can assign an award category to a project" do
            @project.awards.create!(:award_category => @award_category)
            @project.should have_won_award
            @project.award_categories.size.should == 1
          end
        end
      end
    end
  end

end
