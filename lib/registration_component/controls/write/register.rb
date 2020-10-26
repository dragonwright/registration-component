module RegistrationComponent
  module Controls
    module Write
      module Register
        def self.call(
          id: nil,
          player_email_address_claim_id: nil,
          player_id: nil,
          email_address: nil
        )
          id ||= Registration.id
          player_email_address_claim_id ||= ID.example
          player_id ||= Player.id
          email_address ||= Registration.email_address

          register = Commands::Register.example(
            id: id,
            player_email_address_claim_id: player_email_address_claim_id,
            player_id: player_id,
            email_address: email_address
          )

          stream_name = Messaging::StreamName.command_stream_name(id, 'registration')

          Messaging::Postgres::Write.(register, stream_name)
        end
      end
    end
  end
end
