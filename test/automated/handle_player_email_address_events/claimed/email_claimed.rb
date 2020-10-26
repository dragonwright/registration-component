require_relative '../../automated_init'

context "Handle Player Email Address Events" do
  context "Claimed" do
    context "Email Claimed" do
      handler = Handlers::PlayerEmailAddress::Events.new
      claimed = PlayerEmailAddress::Client::Controls::Events::Claimed.example

      registration = Controls::Registration::Initiated.example
      registration_id = registration.id
      registration_version = Controls::Version.example

      registration_stream_name = "registration-#{registration_id}"
      claimed.metadata.correlation_stream_name = registration_stream_name

      clock_time = Controls::Time::Processed::Raw.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        claimed,
        registration,
        registration_version,
        clock_time: clock_time
      ) do |handler|
        email_claimed = handler.assert_write(Messages::Events::EmailClaimed) do |write|
          write.assert_stream_name(registration_stream_name)
          write.assert_expected_version(registration_version)
        end

        handler.assert_written_message(email_claimed) do |email_claimed|
          email_claimed.assert_attributes_copied([
            :player_email_address_claim_id,
            :player_id,
            :email_address,
            :time
          ])

          email_claimed.assert_attribute_value(:registration_id, registration_id)
          email_claimed.assert_attribute_value(:processed_time, Clock.iso8601(clock_time))

          email_claimed.assert_attributes_assigned
        end
      end
    end
  end
end
