# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'rubygems'

ENV["RAILS_ENV"] = 'test'
require_relative "dummy/config/environment"
require 'rspec/rails'
require 'capybara/rails'
require 'paper_trail/frameworks/rspec'

require 'factory_bot_rails'
require 'ffaker'
require 'timecop'
require 'webdrivers'
require 'database_cleaner'
require 'rails-controller-testing'
require 'rspec-activemodel-mocks'
require 'puma'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

# Load shared behavior modules to be included by Runner config.
Dir["./spec/shared/**/*.rb"].sort.each { |f| require f }

TASK_STATUSES = %w[pending assigned completed].freeze

I18n.locale = 'en-US'

Paperclip.options[:log] = false

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
#FactoryBot.find_definitions

RSpec.configure do |config|
  [:controller, :view, :request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, :type => type
    config.include ::Rails::Controller::Testing::TemplateAssertions, :type => type
    config.include ::Rails::Controller::Testing::Integration, :type => type
  end

  config.infer_spec_type_from_file_location!

  config.mock_with :rspec

  config.fixture_path = "#{Rails.root}/spec/fixtures"

  # RSpec configuration options for Fat Free CRM.
  config.include RSpec::Rails::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :features
  config.include Warden::Test::Helpers
  config.include DeviseHelpers
  config.include FeatureHelpers
  config.include AbilityAndRouteHelpers, type: :view

  Warden.test_mode!

  config.before(:each, type: :view) do
    add_routes_and_ability_to_view(view)
  end

  config.before(:each) do
    # Overwrite locale settings within "config/settings.yml" if necessary.
    # In order to ensure that test still pass if "Setting.locale" is not set to "en-US".
    I18n.locale = 'en-US'
    Setting.locale = 'en-US' unless Setting.locale == 'en-US'
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

ActionView::TestCase::TestController.class_eval do
  def controller_name
    HashWithIndifferentAccess.new(request.path_parameters)["controller"].split('/').last
  end
end

ActionView::Base.class_eval do
  def controller_name
    HashWithIndifferentAccess.new(request.path_parameters)["controller"].split('/').last
  end

  def called_from_index_page?(controller = controller_name)
    request.referer =~ if controller != "tasks"
                         %r{/#{controller}$}
                       else
                         /tasks\?*/
                       end
  end

  def called_from_landing_page?(controller = controller_name)
    request.referer =~ %r{/#{controller}/\w+}
  end
end
