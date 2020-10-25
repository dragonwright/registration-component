ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'entity_projection/fixtures'
require 'messaging/fixtures'

require 'pp'

require 'registration_component/controls'
require 'player_email_address/client/controls'

module RegistrationComponent; end
include RegistrationComponent
