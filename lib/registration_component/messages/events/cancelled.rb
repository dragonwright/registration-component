module RegistrationComponent
  module Messages
    module Events
      class Cancelled
        include Messaging::Message

        attribute :registration_id, String
        attribute :player_id, String
        attribute :email_address, String
        attribute :time, String
      end
    end
  end
end
