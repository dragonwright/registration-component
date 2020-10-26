require 'registration/client'
require 'registration/client/controls'

registration_id = Identifier::UUID::Random.get
player_email_address_claim_id = Identifier::UUID::Random.get
email_address = "test+#{registration_id}@test.com"
player_id = '123'

Registration::Client::Register.(
  registration_id: registration_id,
  player_email_address_claim_id: player_email_address_claim_id,
  player_id: player_id,
  email_address: email_address
)

stream_name = Messaging::StreamName.stream_name(registration_id, 'registration')

sleep 1

registered_data = MessageStore::Postgres::Get::Stream::Last.(stream_name)

pp registered_data
