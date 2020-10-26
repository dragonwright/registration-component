require_relative './interactive_init'

registration_id = Identifier::UUID::Random.get

player_email_address_claim_id = Identifier::UUID::Random.get

player_id = '123'

email_address = 'test@test.com'

Controls::Write::Register.(
  id: registration_id,
  player_email_address_claim_id: player_email_address_claim_id,
  player_id: player_id,
  email_address: email_address
)
