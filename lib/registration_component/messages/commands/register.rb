module RegistrationComponent
  module Messages
    module Commands
      class Register
        include Messaging::Message

        attribute :registration_id, String
        attribute :player_email_address_claim_id, String
        attribute :player_id, String
        attribute :email_address, String
        attribute :time, String
      end
    end
  end
end
