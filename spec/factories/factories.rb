FactoryGirl.define do

  factory :admin do
    email "admin@rewiredstate.org"
    password "password"
  end

  factory :event do
    sequence(:title) {|n| "Hack all the things ##{n}"}
    sequence(:slug) {|n| "hack-everything-#{n}"}
    start_date { Date.today }

    factory :event_with_centres do
      use_centres true
    end
  end

  factory :centre do
    sequence(:name) {|n| "Centre #{n}"}
    sequence(:slug) {|n| "centre-#{n}"}

    event
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

    secret "secret"
    event
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
