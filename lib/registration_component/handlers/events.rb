module RegistrationComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Events

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC
      dependency :store, Store
      dependency :claim, ::PlayerEmailAddress::Client::Claim

      def configure(session: nil)
        Messaging::Postgres::Write.configure(self, session: session)
        Clock::UTC.configure(self)
        Store.configure(self, session: session)
        ::PlayerEmailAddress::Client::Claim.configure(self, session: session)
      end

      category :registration

      handle Initiated do |initiated|
        player_email_address_claim_id = initiated.player_email_address_claim_id
        player_id = initiated.player_id
        email_address = initiated.email_address

        claim.(
          player_email_address_claim_id: player_email_address_claim_id,
          player_id: player_id,
          email_address: email_address,
          previous_message: initiated
        )
      end

      handle EmailClaimed do |email_claimed|
        registration_id = email_claimed.registration_id

        registration, version = store.fetch(registration_id, include: :version)

        if registration.registered?
          logger.info(tag: :ignored) { "Event ignored (Event: #{email_claimed.message_type}, Registration ID: #{registration_id}, Player ID: #{email_claimed.player_id})" }
          return
        end

        time = clock.iso8601

        stream_name = stream_name(registration_id)

        registered = Registered.follow(email_claimed, exclude: [
          :player_email_address_claim_id,
          :time,
          :processed_time
        ])
        registered.time = time

        write.(registered, stream_name, expected_version: version)
      end

      handle EmailRejected do |email_rejected|
        registration_id = email_rejected.registration_id

        registration, version = store.fetch(registration_id, include: :version)

        if registration.cancelled?
          logger.info(tag: :ignored) { "Event ignored (Event: #{email_rejected.message_type}, Registration ID: #{registration_id}, Player ID: #{email_rejected.player_id})" }
          return
        end

        time = clock.iso8601

        stream_name = stream_name(registration_id)

        cancelled = Cancelled.follow(email_rejected, exclude: [
          :player_email_address_claim_id,
          :time,
          :processed_time
        ])
        cancelled.time = time

        write.(cancelled, stream_name, expected_version: version)
      end
    end
  end
end
