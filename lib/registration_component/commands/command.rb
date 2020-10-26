module RegistrationComponent
  module Commands
    module Command
      def self.included(cls)
        cls.class_exec do
          include Dependency

          include Messaging::StreamName
          include Messages::Events

          extend Build
          extend BuildMessage

          category :registration

          dependency :write, Messaging::Postgres::Write
          dependency :clock, Clock::UTC
        end
      end

      def configure(session: nil)
        Messaging::Postgres::Write.configure(self, session: session)
        Clock::UTC.configure(self)
      end

      module Build
        def build(**kwargs)
          instance = new
          instance.configure(**kwargs)
          instance
        end
      end

      module BuildMessage
        def build_message(message_class, previous_message)
          message = message_class.new

          unless previous_message.nil?
            message.metadata.follow(previous_message.metadata)
          end

          message
        end
      end
    end
  end
end
