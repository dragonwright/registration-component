module RegistrationComponent
  module Controls
    module Events
      module Registered
        def self.example
          registered = RegistrationComponent::Messages::Events::Registered.build

          registered.registration_id = Registration.id
          registered.player_id = Player.id
          registered.email_address = Registration.email_address
          registered.time = Controls::Time::Effective.example

          registered
        end
      end
    end
  end
end
