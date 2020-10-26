require_relative '../../automated_init'

context "Handle Player Email Address Events" do
  context "Claim Rejected" do
    context "Email Rejected" do
      handler = Handlers::PlayerEmailAddress::Events.new
      claim_rejected = PlayerEmailAddress::Client::Controls::Events::ClaimRejected.example

      registration = Controls::Registration::Initiated.example
      registration_id = registration.id
      registration_version = Controls::Version.example

      registration_stream_name = "registration-#{registration_id}"
      claim_rejected.metadata.correlation_stream_name = registration_stream_name

      clock_time = Controls::Time::Processed::Raw.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        claim_rejected,
        registration,
        registration_version,
        clock_time: clock_time
      ) do |handler|
        email_rejected = handler.assert_write(Messages::Events::EmailRejected) do |write|
          write.assert_stream_name(registration_stream_name)
          write.assert_expected_version(registration_version)
        end

        handler.assert_written_message(email_rejected) do |email_rejected|
          email_rejected.assert_attributes_copied([
            :player_email_address_claim_id,
            :player_id,
            :email_address,
            :time
          ])

          email_rejected.assert_attribute_value(:registration_id, registration_id)
          email_rejected.assert_attribute_value(:processed_time, Clock.iso8601(clock_time))

          email_rejected.assert_attributes_assigned
        end
      end
    end
  end
end
