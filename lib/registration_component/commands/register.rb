module RegistrationComponent
  module Commands
    class Register
      include Command

      def self.configure(receiver, attr_name: nil, **kwargs)
        attr_name ||= :register
        instance = build(**kwargs)
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(
        registration_id:,
        player_email_address_claim_id:,
        player_id:,
        email_address:,
        previous_message: nil
      )
        instance = self.build
        instance.(
          registration_id: registration_id,
          player_email_address_claim_id: player_email_address_claim_id,
          player_id: player_id,
          email_address: email_address,
          previous_message: previous_message
        )
      end

      def call(
        registration_id:,
        player_email_address_claim_id:,
        player_id:,
        email_address:,
        previous_message: nil
      )
        register = self.class.build_message(Messages::Commands::Register, previous_message)

        register.registration_id = registration_id
        register.player_email_address_claim_id = player_email_address_claim_id
        register.player_id = player_id
        register.email_address = email_address
        register.time = clock.iso8601

        stream_name = command_stream_name(registration_id)

        write.(register, stream_name)

        register
      end
    end
  end
end
