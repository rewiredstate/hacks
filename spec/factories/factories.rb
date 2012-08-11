FactoryGirl.define do

  factory :admin do
    email "admin@rewiredstate.org"
    password "password"
  end

  factory :event do
    sequence(:title) {|n| "Hack all the things ##{n}"}
    sequence(:slug) {|n| "hack-everything-#{n}"}
    secret "secret"

    factory :event_without_secret do
      secret nil
    end
  end

  factory :project do
    sequence(:title) {|n| "Project ##{n}"}
    team "Lots of people"
    description "Description of the hack"
    summary "Summary of the hack"
    url "http://example.com/"
    twitter "@twitter"
    github_url "https://github.com/github/github"
    image { stub_uploaded_image }

    factory :project_with_secret do
      association :event, :secret => nil
      secret "secret"
    end

    factory :project_with_event_secret do
      association :event, :secret => "secret"
      my_secret "secret"
    end
  end

  factory :award_category do
    title "Best in Show"
    description "The most outstanding hack created."
    format "overall"
    level 1
    featured true
    event
  end

end
