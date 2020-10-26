require_relative '../../automated_init'

context "Handle Events" do
  context "Initiated" do
    context "Claim" do
      handler = Handlers::Events.new

      claim_client = PlayerEmailAddress::Client::Claim.new
      handler.claim = claim_client

      processed_time = Controls::Time::Processed::Raw.example

      claim_client.clock.now = processed_time

      initiated = Controls::Events::Initiated.example

      registration_id = initiated.registration_id or fail
      player_email_address_claim_id = initiated.player_email_address_claim_id or fail
      player_id = initiated.player_id or fail
      email_address = initiated.email_address or fail
      effective_time = initiated.time or fail

      initiated.metadata.correlation_stream_name = "someCorrelationStream"

      encoded_email_address = Controls::Registration.encoded_email_address

      customer_email_command_stream_name = "playerEmailAddress:command-#{encoded_email_address}"

      handler.(initiated)

      writer = claim_client.write

      claim = writer.one_message do |event|
        event.instance_of?(PlayerEmailAddress::Client::Messages::Commands::Claim)
      end

      test "Claim command is written" do
        refute(claim.nil?)
      end

      test "Written to the customer email command stream" do
        written_to_stream = writer.written?(claim) do |stream_name|
          stream_name == customer_email_command_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "player_email_address_claim_id" do
          assert(claim.player_email_address_claim_id == player_email_address_claim_id)
        end

        test "encoded_email_address" do
          assert(claim.encoded_email_address == encoded_email_address)
        end

        test "player_id" do
          assert(claim.player_id == player_id)
        end

        test "email_address" do
          assert(claim.email_address == email_address)
        end

        test "time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(claim.time == processed_time_iso8601)
        end
      end

      context "Metadata" do
        test "Follows previous message" do
          assert(claim.metadata.correlates?(initiated.metadata.correlation_stream_name))
        end
      end
    end
  end
end
