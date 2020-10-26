require_relative '../../automated_init'

context "Commands" do
  context "Register" do
    context "Previous Message" do
      previous_message = Controls::Message.example

      registration_id = Controls::Registration.id
      player_email_address_claim_id = Controls::PlayerEmailAddress::Claim.id
      player_id = Controls::Player.id
      email_address = Controls::Registration.email_address

      register = Commands::Register.new
      register.clock.now = Controls::Time::Raw.example

      register.(
        registration_id: registration_id,
        player_email_address_claim_id: player_email_address_claim_id,
        player_id: player_id,
        email_address: email_address,
        previous_message: previous_message
      )

      write = register.write

      register_message = write.one_message do |written|
        written.instance_of?(Messages::Commands::Register)
      end

      refute(register_message.nil?)

      test "Register message follows previous message" do
        assert(register_message.follows?(previous_message))
      end
    end
  end
end
