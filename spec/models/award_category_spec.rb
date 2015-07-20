require 'rails_helper'

RSpec.describe AwardCategory, type: :model do

  let(:event) { create(:event) }

  describe "creating an award category" do
    let(:attributes) { attributes_for(:award_category) }

    context "given valid attributes" do
      it "can create an award category" do
        award_category = event.award_categories.create(attributes)

        expect(award_category).to be_persisted
      end

      it "features the award category by default" do
        award_category = event.award_categories.create!(attributes)

        expect(award_category).to be_featured
      end
    end

    context "given invalid attributes" do
      it "can't create an award category without a title" do
        award_category = event.award_categories.build(attributes.merge(title: nil))

        expect(award_category).to_not be_valid
      end

      it "can't create an award category without a format" do
        award_category = event.award_categories.build(attributes.merge(format: nil))

        expect(award_category).to_not be_valid
      end

      it "can't create an award category with an invalid format" do
        award_category = event.award_categories.build(attributes.merge(format: 'something else'))

        expect(award_category).to_not be_valid
      end

      it "can't create an award category without a level" do
        award_category = event.award_categories.build(attributes.merge(level: nil))

        expect(award_category).to_not be_valid
      end

      it "can't create an award category with an invalid level" do
        award_category = event.award_categories.build(attributes.merge(level: 'aaaabc'))

        expect(award_category).to_not be_valid
      end
    end
  end

end
