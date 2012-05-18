ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

  config.infer_base_class_for_anonymous_controllers = false
end

def stub_uploaded_image(filename = 'image.jpg')
  Project.stub!(:has_attached_file).with(:image).and_return(true)
  File.new("spec/fixtures/paperclip/#{filename}")
end