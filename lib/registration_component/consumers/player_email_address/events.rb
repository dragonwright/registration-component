module RegistrationComponent
  module Consumers
    module PlayerEmailAddress
      class Events
        include Consumer::Postgres

        handler Handlers::PlayerEmailAddress::Events
      end
    end
  end
end
