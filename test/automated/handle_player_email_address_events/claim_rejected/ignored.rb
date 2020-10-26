require_relative '../../automated_init'

context "Handle Player Email Address Events" do
  context "Claim Rejected" do
    context "Ignored" do
      handler = Handlers::PlayerEmailAddress::Events.new
      claim_rejected = PlayerEmailAddress::Client::Controls::Events::ClaimRejected.example

      registration = Controls::Registration::EmailRejected.example

      registration_stream_name = "registration-#{registration.id}"
      claim_rejected.metadata.correlation_stream_name = registration_stream_name

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        claim_rejected,
        registration
      ) do |handler|
        handler.refute_write
      end
    end
  end
end
