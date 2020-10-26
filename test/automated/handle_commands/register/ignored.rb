require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Ignored" do
      handler = Handlers::Commands.new
      register = Controls::Commands::Register.example

      registration = Controls::Registration::Initiated.example

      fixture(
        Messaging::Fixtures::Handler,
        handler,
        register,
        registration
      ) do |handler|
        handler.refute_write
      end
    end
  end
end
