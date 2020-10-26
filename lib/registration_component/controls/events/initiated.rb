module RegistrationComponent
  module Controls
    module Events
      module Initiated
        def self.example
          initiated = RegistrationComponent::Messages::Events::Initiated.build

          initiated.registration_id = Registration.id
          initiated.player_email_address_claim_id = PlayerEmailAddress::Claim.id
          initiated.player_id = Player.id
          initiated.email_address = Registration.email_address
          initiated.time = Controls::Time::Effective.example
          initiated.processed_time = Controls::Time::Processed.example

          initiated
        end
      end
    end
  end
end
