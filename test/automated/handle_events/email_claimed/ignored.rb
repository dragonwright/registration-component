require_relative '../../automated_init'

context "Handle Events" do
  context "Email Claimed" do
    context "Ignored" do
      handler = Handlers::Events.new
      email_claimed = Controls::Events::EmailClaimed.example

      registration = Controls::Registration::Registered.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        email_claimed,
        registration
      ) do |handler|
        handler.refute_write
      end
    end
  end
end
