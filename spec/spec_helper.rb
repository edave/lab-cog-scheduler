require 'rubygems'
require 'spork'

# From http://ykyuen.wordpress.com/2010/12/14/rails-running-rspec-with-spork-test-server/
Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'faker'
  require 'factory_girl_rails'
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
    config.use_instantiated_fixtures  = false
    
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    ### Part of a Spork hack. See http://bit.ly/arY19y
    # Emulate initializer set_clear_dependencies_hook in
    # railties/lib/rails/application/bootstrap.rb
    # ActiveSupport::Dependencies.clear
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  #FactoryGirl.definition_file_paths = [
  #        File.join(Rails.root, 'spec', 'factories')
  #]
  #FactoryGirl.find_definitions
  #FactoryGirl.factories.clear
  
  ExperimentTracker::Application.reload_routes!
  
  # From http://mikbe.tk/2011/02/10/blazingly-fast-tests/
  #Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f } # Reload application files everytime
end
