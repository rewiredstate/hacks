require 'rails_helper'

RSpec.describe Project do

  let(:event) { create(:event) }

  describe "#create" do
    let(:valid_attributes) { attributes_for(:project) }

    describe "given valid attributes" do
      it "can be created" do
        project = event.projects.create!(valid_attributes)
        expect(project).to be_persisted
      end

      it "sets the slug based on the title" do
        project = event.projects.create!(valid_attributes)

        expect(project.slug).to eq(valid_attributes[:title].parameterize)
      end

      describe "the created project" do
        it "has not won awards" do
          project = event.projects.create!(valid_attributes)
          expect(project).to_not have_won_award
        end
      end
    end

    describe "given invalid attributes" do
      it "can't be created if the event no longer allows new projects to be created" do
        event = create(:event, enable_project_creation: false)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created with an empty project password" do
        valid_attributes.merge!(secret: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created without a screenshot" do
        valid_attributes.merge!(image: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created without a title" do
        valid_attributes.merge!(title: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created without a team name" do
        valid_attributes.merge!(team: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created without a summary" do
        valid_attributes.merge!(summary: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created with a summary longer than 180 characters" do
        valid_attributes.merge!(summary: "test".ljust(181))
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created without a description" do
        valid_attributes.merge!(description: nil)
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created with an invalid url" do
        valid_attributes.merge!(url: "this does not look like a valid url")
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end

      it "can't be created with an invalid image" do
        valid_attributes.merge!(image: stub_uploaded_image("invalid_image_file"))
        project = event.projects.build(valid_attributes)

        expect(project).to_not be_valid
      end
    end

    describe "where the event has centres" do
      let(:event) { create(:event_with_centres) }
      let(:centre) { create(:centre, event: event) }
      let(:attributes) {
        attributes_for(:project).merge(centre: centre)
      }

      describe "given valid attributes" do
        it "can be created" do
          project = event.projects.create!(attributes)

          expect(project).to be_persisted
        end
      end

      describe "given invalid attributes" do
        it "can't be created without a centre" do
          project = event.projects.build(attributes.merge(centre: nil))

          expect(project).to_not be_valid
        end
      end
    end
  end

  describe '#update_attributes_with_secret' do
    let(:project) { create(:project) }
    let(:attributes) {
      { title: 'updated title' }
    }

    it 'updates attributes given the valid secret' do
      project.update_attributes_with_secret(project.secret, attributes)
      project.reload

      expect(project.title).to eq(attributes[:title])
    end

    it 'does not update attributes given an invalid secret' do
      expect(
        project.update_attributes_with_secret('not the secret', attributes)
      ).to eq(false)

      expect(project.errors).to have_key(:secret)
    end

    it 'does not update attributes given a blank secret' do
      expect(
        project.update_attributes_with_secret('', attributes)
      ).to eq(false)

      expect(project.errors).to have_key(:secret)
    end
  end

end
