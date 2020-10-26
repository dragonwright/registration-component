require_relative '../../automated_init'

context "Handle Events" do
  context "Email Rejected" do
    context "Ignored" do
      handler = Handlers::Events.new
      email_rejected = Controls::Events::EmailRejected.example

      registration = Controls::Registration::Cancelled.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        email_rejected,
        registration
      ) do |handler|
        handler.refute_write
      end
    end
  end
end
