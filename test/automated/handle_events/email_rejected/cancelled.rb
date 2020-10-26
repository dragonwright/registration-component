require_relative '../../automated_init'

context "Handle Events" do
  context "Email Rejected" do
    context "Registered" do
      handler = Handlers::Events.new
      email_rejected = Controls::Events::EmailRejected.example

      registration = Controls::Registration::EmailRejected.example
      registration_version = Controls::Version.example

      clock_time = Controls::Time::Processed::Raw.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        email_rejected,
        registration,
        registration_version,
        clock_time: clock_time
      ) do |handler|
        cancelled = handler.assert_write(Messages::Events::Cancelled) do |write|
          write.assert_stream_name("registration-#{registration.id}")
          write.assert_expected_version(registration_version)
        end

        handler.assert_written_message(cancelled) do |cancelled|
          cancelled.assert_attributes_copied([
            :registration_id,
            :player_id,
            :email_address
          ])

          cancelled.assert_attribute_value(:time, Clock.iso8601(clock_time))

          cancelled.assert_attributes_assigned
        end
      end
    end
  end
end
