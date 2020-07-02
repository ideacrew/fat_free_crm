require_relative 'lib/fat_free_crm/version'

Gem::Specification.new do |gem|
  gem.name = 'fat_free_crm'
  gem.authors = ['Ideacrew']
  gem.summary = 'Fat Free CRM'
  gem.description = 'An open source, Ruby on Rails customer relationship management platform'
  gem.homepage = 'http://fatfreecrm.com'
  gem.email = ['info@ideacrew.com']
  gem.version = FatFreeCrm::VERSION::STRING
  gem.required_ruby_version = '>= 2.4.0'
  gem.license = 'MIT'

  gem.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|gem|features)/}) }
  end

  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rails', '~> 6.0'
  gem.add_runtime_dependency 'activejob', '~> 6.0'

  gem.add_runtime_dependency 'pg'
  gem.add_runtime_dependency 'sass-rails'
  gem.add_runtime_dependency 'coffee-rails'
  gem.add_runtime_dependency 'uglifier'
  gem.add_runtime_dependency 'execjs'
  gem.add_runtime_dependency 'bootsnap'
  gem.add_runtime_dependency 'tzinfo-data'
  gem.add_runtime_dependency 'rails-observers'
  gem.add_runtime_dependency 'rmagick'

  gem.add_runtime_dependency 'devise'
  gem.add_runtime_dependency 'devise-i18n'
  gem.add_runtime_dependency 'devise-encryptable'
  gem.add_runtime_dependency 'cancancan'
  gem.add_runtime_dependency 'rails-i18n'
  gem.add_runtime_dependency 'active_model_serializers'
  gem.add_runtime_dependency 'activemodel-serializers-xml'
  gem.add_runtime_dependency 'responders'

  gem.add_runtime_dependency 'jquery-rails'
  gem.add_runtime_dependency 'jquery-migrate-rails'
  gem.add_runtime_dependency 'jquery-ui-rails'
  gem.add_runtime_dependency 'rails3-jquery-autocomplete'
  gem.add_runtime_dependency 'select2-rails'
  gem.add_runtime_dependency 'simple_form'
  gem.add_runtime_dependency 'will_paginate'

  gem.add_runtime_dependency 'paperclip'
  gem.add_runtime_dependency 'paper_trail'
  gem.add_runtime_dependency 'acts_as_commentable'
  gem.add_runtime_dependency 'acts-as-taggable-on'
  gem.add_runtime_dependency 'acts_as_list'

  gem.add_runtime_dependency 'dynamic_form'
  gem.add_runtime_dependency 'haml'
  gem.add_runtime_dependency 'responds_to_parent'
  gem.add_runtime_dependency 'rails_autolink'
  gem.add_runtime_dependency 'country_select'


  # FatFreeCrm has released it's own versions of the following gems:
  #-----------------------------------------------------------------
  gem.add_runtime_dependency 'ransack', '>= 1.6.2'
  gem.add_runtime_dependency 'ransack_ui', '~> 1.3', '>= 1.3.1'
  gem.add_runtime_dependency 'email_reply_parser_ffcrm'

  # Development dependencies
  #-----------------------------------------------------------------
  gem.add_development_dependency 'puma'
  gem.add_development_dependency 'pry-byebug'
  gem.add_development_dependency 'pry-rails'
  gem.add_development_dependency 'pry-stack_explorer'
  gem.add_development_dependency 'factory_bot_rails'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'capybara-screenshot'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'rspec-activemodel-mocks'
  gem.add_development_dependency 'headless'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'selenium-webdriver'
  gem.add_development_dependency 'webdrivers'
  gem.add_development_dependency 'database_cleaner'
  gem.add_development_dependency 'zeus' #, platform: :ruby
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'sprockets-rails'
  gem.add_development_dependency 'sass'
  gem.add_development_dependency 'ffaker', '>= 2'
  gem.add_development_dependency 'font-awesome-rails'
  gem.add_development_dependency 'premailer'
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'rails-controller-testing'
  # gem.add_development_dependency 'ransack', '>= 1.6.2'
  # gem.add_development_dependency 'ransack_ui', '~> 1.3', '>= 1.3.1'
  gem.add_development_dependency 'ransack_chronic'
  gem.add_development_dependency 'thor'
  gem.add_development_dependency 'coffee-script-source'

end
