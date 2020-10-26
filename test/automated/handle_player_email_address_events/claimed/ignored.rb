require_relative '../../automated_init'

context "Handle Player Email Address Events" do
  context "Claimed" do
    context "Ignored" do
      handler = Handlers::PlayerEmailAddress::Events.new
      claimed = PlayerEmailAddress::Client::Controls::Events::Claimed.example

      registration = Controls::Registration::EmailClaimed.example

      registration_stream_name = "registration-#{registration.id}"
      claimed.metadata.correlation_stream_name = registration_stream_name

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        claimed,
        registration
      ) do |handler|
        handler.refute_write
      end
    end
  end
end
