require 'rails_helper'

RSpec.describe Centre, type: :model do

  let(:event) { create(:event_with_centres) }

  describe "creating a centre" do
    let(:attributes) {
      attributes_for(:centre)
    }

    context "given valid attributes" do
      it "can create a centre" do
        event.centres.create!(attributes)
      end

      it "can set a slug if none exists" do
        centre = event.centres.create!( attributes.merge(slug: nil) )

        expect(centre.slug).to eq(attributes[:name].parameterize)
      end

      it "doesn't generate a slug if one is present" do
        centre = event.centres.create!( attributes )

        expect(centre.slug).to eq(attributes[:slug])
      end

      it "can generate a unique slug where a centre with the same name exists" do
        centre_one = event.centres.create!( attributes.merge(slug: nil) )
        centre_two = event.centres.create!( attributes.merge(slug: nil) )

        expect(centre_one.slug).to eq(attributes[:name].parameterize)
        expect(centre_two.slug).to eq("#{attributes[:name].parameterize}-2")
      end
    end

    context "given invalid attributes" do
      it "can't create a centre without a name" do
        centre = event.centres.build(attributes.merge(name: nil))

        expect(centre).to_not be_valid
        expect(centre.errors).to have_key(:name)
      end
    end
  end

end
