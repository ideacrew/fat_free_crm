# frozen_string_literal: true

# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require 'spec_helper'
require 'rails_helper'
require 'capybara-screenshot/rspec'

ENV["RAILS_ROOT"] ||= File.expand_path(File.dirname(__FILE__) + '/dummy')

# Put your acceptance spec helpers inside /spec/features/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
