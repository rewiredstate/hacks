require 'spec_helper'

describe AwardCategory do

  describe "creating an award category" do
    before do
      @event = FactoryGirl.create(:event)
      @valid_attributes = {
        :title => 'Best in Show',
        :description => 'The best hack',
        :level => '1',
        :format => 'overall'
      }
    end

    context "given valid attributes" do
      it "can create an award category" do
        @event.award_categories.create!(@valid_attributes)
      end

      it "features the award category by default" do
        @award_category = @event.award_categories.create!(@valid_attributes)
        @award_category.featured.should == true
      end
    end

    context "given invalid attributes" do
      it "can't create an award category without a title" do
        @award_category = @event.award_categories.build(@valid_attributes.merge({ :title => nil }))
        @award_category.should_not be_valid
      end

      it "can't create an award category without a format" do
        @award_category = @event.award_categories.build(@valid_attributes.merge({ :format => nil }))
        @award_category.should_not be_valid
      end

      it "can't create an award category with an invalid format" do
        @award_category = @event.award_categories.build(@valid_attributes.merge({ :format => 'something else' }))
        @award_category.should_not be_valid
      end

      it "can't create an award category without a level" do
        @award_category = @event.award_categories.build(@valid_attributes.merge({ :level => nil }))
        @award_category.should_not be_valid
      end

      it "can't create an award category with an invalid level" do
        @award_category = @event.award_categories.build(@valid_attributes.merge({ :level => 'aaaabc' }))
        @award_category.should_not be_valid
      end
    end
  end

end
