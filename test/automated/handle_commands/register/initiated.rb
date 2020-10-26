require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Initiated" do
      handler = Handlers::Commands.new
      register = Controls::Commands::Register.example

      registration = Controls::Registration::New.example

      clock_time = Controls::Time::Processed::Raw.example

      registration_stream_name = "registration-#{register.registration_id}"

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        register,
        registration,
        clock_time: clock_time
      ) do |handler|
        initiated = handler.assert_write(Messages::Events::Initiated) do |write|
          write.assert_stream_name(registration_stream_name)
          write.assert_expected_version(:no_stream)
        end

        handler.assert_written_message(initiated) do |initiated|
          initiated.assert_attributes_copied([
            :registration_id,
            :player_email_address_claim_id,
            :player_id,
            :email_address,
            :time
          ])

          initiated.assert_attribute_value(:processed_time, Clock.iso8601(clock_time))

          initiated.assert_attributes_assigned

          initiated.assert_metadata do |metadata|
            metadata.assert_correlation_stream_name(registration_stream_name)
          end
        end
      end
    end
  end
end
