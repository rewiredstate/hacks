require 'spec_helper'

describe Centre do

  describe "creating a centre" do
    before do
      @event = FactoryGirl.create(:event, :use_centres => true)
      @valid_attributes = {
        :name => "London",
        :slug => "centre-slug"
      }
    end

    context "given valid attributes" do
      it "can create a centre" do
        @event.centres.create!(@valid_attributes)
      end

      it "can set a slug if none exists" do
        @centre = @event.centres.create!( @valid_attributes.merge({:slug => nil}) )
        @centre.slug.should == "london"
      end

      it "doesn't generate a slug if one is present" do
        @centre = @event.centres.create!( @valid_attributes )
        @centre.slug.should == "centre-slug"
      end

      it "can generate a unique slug where a centre with the same name exists" do
        @centre_one = @event.centres.create!( @valid_attributes.merge({:slug => nil}) )
        @centre_two = @event.centres.create!( @valid_attributes.merge({:slug => nil}) )

        @centre_one.slug.should == "london"
        @centre_two.slug.should == "london-2"
      end
    end

    context "given invalid attributes" do
      it "can't create an award category without a name" do
        @centre = @event.centres.build(@valid_attributes.merge({ :name => nil }))
        @centre.should_not be_valid
      end
    end
  end

end
