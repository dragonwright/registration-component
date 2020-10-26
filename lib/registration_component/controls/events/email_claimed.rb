module RegistrationComponent
  module Controls
    module Events
      module EmailClaimed
        def self.example
          email_claimed = RegistrationComponent::Messages::Events::EmailClaimed.build

          email_claimed.registration_id = Registration.id
          email_claimed.player_email_address_claim_id = PlayerEmailAddress::Claim.id
          email_claimed.player_id = Player.id
          email_claimed.email_address = Registration.email_address
          email_claimed.time = Controls::Time::Effective.example
          email_claimed.processed_time = Controls::Time::Processed.example

          email_claimed
        end
      end
    end
  end
end
