require 'spec_helper'

describe ProjectsHelper do

  describe "#format_github_url" do
    it "returns the username and repository when given a valid http url" do
      helper.format_github_url("http://github.com/someuser/somerepo").should == "someuser/somerepo"
    end

    it "returns the username and repository when given a valid https url" do
      helper.format_github_url("https://github.com/someuser/somerepo").should == "someuser/somerepo"
    end

    it "returns the full url when a url with another host is provided" do
      helper.format_github_url("https://definitely-not-github.com/blah").should == "https://definitely-not-github.com/blah"
    end

    it "returns the full url when a url with another host is provided with two parts to the path" do
      helper.format_github_url("https://definitely-not-github.com/someuser/somerepo").should == "https://definitely-not-github.com/someuser/somerepo"
    end

    it "returns the username when a url on github.com does not have a user and repo" do
      helper.format_github_url("https://github.com/someuser").should == "someuser"
    end
  end

end
