require 'eventide/postgres'
require 'consumer/postgres'

require 'player_email_address/client'

require 'registration_component/load'

require 'registration_component/registration'
require 'registration_component/projection'
require 'registration_component/store'

require 'registration_component/handlers/commands'
require 'registration_component/handlers/events'
require 'registration_component/handlers/player_email_address/events'

require 'registration_component/consumers/commands'
require 'registration_component/consumers/events'
require 'registration_component/consumers/player_email_address/events'

require 'registration_component/start'
