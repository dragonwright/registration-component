module RegistrationComponent
  module Handlers
    module PlayerEmailAddress
      class Events
        include Log::Dependency
        include Messaging::Handle
        include Messaging::StreamName
        include Messages::Events

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, Store

        def configure(session: nil)
          Messaging::Postgres::Write.configure(self, session: session)
          Clock::UTC.configure(self)
          Store.configure(self, session: session)
        end

        category :registration

        handle ::PlayerEmailAddress::Client::Messages::Events::Claimed do |claimed|
          correlation_stream_name = claimed.metadata.correlation_stream_name
          registration_id = Messaging::StreamName.get_id(correlation_stream_name)

          registration, version = store.fetch(registration_id, include: :version)

          if registration.email_claimed?
            logger.info(tag: :ignored) { "Event ignored (Event: #{claimed.class.name}, Registration ID: #{registration_id}, Player ID: #{claimed.player_id})" }
            return
          end

          email_claimed = EmailClaimed.follow(claimed, exclude: [
            :encoded_email_address,
            :sequence
          ])
          email_claimed.registration_id = registration_id
          email_claimed.processed_time = clock.iso8601

          stream_name = stream_name(registration_id)

          write.(email_claimed, stream_name, expected_version: version)
        end

        handle ::PlayerEmailAddress::Client::Messages::Events::ClaimRejected do |claim_rejected|
          correlation_stream_name = claim_rejected.metadata.correlation_stream_name
          registration_id = Messaging::StreamName.get_id(correlation_stream_name)

          registration, version = store.fetch(registration_id, include: :version)

          if registration.email_rejected?
            logger.info(tag: :ignored) { "Event ignored (Event: #{claim_rejected.class.name}, Registration ID: #{registration_id}, Player ID: #{claim_rejected.player_id})" }
            return
          end

          email_rejected = EmailRejected.follow(claim_rejected, exclude: [
            :encoded_email_address,
            :sequence
          ])
          email_rejected.registration_id = registration_id
          email_rejected.processed_time = clock.iso8601

          stream_name = stream_name(registration_id)

          write.(email_rejected, stream_name, expected_version: version)
        end
      end
    end
  end
end
