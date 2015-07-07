require 'rails_helper'

RSpec.describe ProjectsHelper do

  describe "#format_github_url" do
    it "returns the username and repository when given a valid http url" do
      output = helper.format_github_url("http://github.com/someuser/somerepo")

      expect(output).to eq("someuser/somerepo")
    end

    it "returns the username and repository when given a valid https url" do
      output = helper.format_github_url("https://github.com/someuser/somerepo")

      expect(output).to eq("someuser/somerepo")
    end

    it "returns the full url when a url with another host is provided" do
      output = helper.format_github_url("https://definitely-not-github.com/blah")

      expect(output).to eq("https://definitely-not-github.com/blah")
    end

    it "returns the full url when a url with another host is provided with two parts to the path" do
      output = helper.format_github_url("https://definitely-not-github.com/someuser/somerepo")

      expect(output).to eq("https://definitely-not-github.com/someuser/somerepo")
    end

    it "returns the username when a url on github.com does not have a user and repo" do
      output = helper.format_github_url("https://github.com/someuser")

      expect(output).to eq("someuser")
    end
  end

end
