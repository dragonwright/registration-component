require_relative '../../automated_init'

context "Handle Events" do
  context "Email Claimed" do
    context "Registered" do
      handler = Handlers::Events.new
      email_claimed = Controls::Events::EmailClaimed.example

      registration = Controls::Registration::EmailClaimed.example
      registration_version = Controls::Version.example

      clock_time = Controls::Time::Processed::Raw.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        email_claimed,
        registration,
        registration_version,
        clock_time: clock_time
      ) do |handler|
        registered = handler.assert_write(Messages::Events::Registered) do |write|
          write.assert_stream_name("registration-#{registration.id}")
          write.assert_expected_version(registration_version)
        end

        handler.assert_written_message(registered) do |registered|
          registered.assert_attributes_copied([
            :registration_id,
            :player_id,
            :email_address
          ])

          registered.assert_attribute_value(:time, Clock.iso8601(clock_time))

          registered.assert_attributes_assigned
        end
      end
    end
  end
end
