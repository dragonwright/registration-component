module RegistrationComponent
  module Controls
    module Commands
      module Register
        def self.example(
          id: nil,
          player_email_address_claim_id: nil,
          player_id: nil,
          email_address: nil
        )
          id ||= Registration.id
          player_email_address_claim_id ||= PlayerEmailAddress::Claim.id
          player_id ||= Player.id
          email_address ||= Registration.email_address

          register = RegistrationComponent::Messages::Commands::Register.build

          register.registration_id = id
          register.player_email_address_claim_id = player_email_address_claim_id
          register.player_id = player_id
          register.email_address = email_address
          register.time = Controls::Time::Effective.example

          register
        end
      end
    end
  end
end
