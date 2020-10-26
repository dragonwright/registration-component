require_relative '../../automated_init'

context "Commands" do
  context "Register" do
    registration_id = Controls::Registration.id
    player_email_address_claim_id = Controls::PlayerEmailAddress::Claim.id
    player_id = Controls::Player.id
    email_address = Controls::Registration.email_address
    effective_time = Controls::Time::Effective::Raw.example

    register = Commands::Register.new
    register.clock.now = effective_time

    register.(
      registration_id: registration_id,
      player_email_address_claim_id: player_email_address_claim_id,
      player_id: player_id,
      email_address: email_address
    )

    write = register.write

    register_message = write.one_message do |written|
      written.instance_of?(Messages::Commands::Register)
    end

    test "Register command is written" do
      refute(register_message.nil?)
    end

    test "Written to the registration command stream" do
      written_to_stream = write.written?(register_message) do |stream_name|
        stream_name == "registration:command-#{registration_id}"
      end

      assert(written_to_stream)
    end

    context "Attributes" do
      test "registration_id is assigned" do
        assert(register_message.registration_id == registration_id)
      end

      test "player_email_address_claim_id" do
        assert(register_message.player_email_address_claim_id == player_email_address_claim_id)
      end

      test "player_id" do
        assert(register_message.player_id == player_id)
      end

      test "email_address" do
        assert(register_message.email_address == email_address)
      end

      test "time" do
        effective_time_iso8601 = Clock.iso8601(effective_time)

        assert(register_message.time == effective_time_iso8601)
      end
    end
  end
end
