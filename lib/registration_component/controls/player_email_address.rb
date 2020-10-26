module RegistrationComponent
  module Controls
    module PlayerEmailAddress
      module Claim
        def self.id
          ID.example(increment: id_increment)
        end

        def self.id_increment
          222
        end
      end
    end
  end
end
