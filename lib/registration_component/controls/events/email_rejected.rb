module RegistrationComponent
  module Controls
    module Events
      module EmailRejected
        def self.example
          email_rejected = RegistrationComponent::Messages::Events::EmailRejected.build

          email_rejected.registration_id = Registration.id
          email_rejected.player_email_address_claim_id = PlayerEmailAddress::Claim.id
          email_rejected.player_id = Player.id
          email_rejected.email_address = Registration.email_address
          email_rejected.time = Controls::Time::Effective.example
          email_rejected.processed_time = Controls::Time::Processed.example

          email_rejected
        end
      end
    end
  end
end
