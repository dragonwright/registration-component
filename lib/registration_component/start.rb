module RegistrationComponent
  class Start
    attr_accessor :settings

    def self.build(settings=nil)
      instance = new
      instance.settings = settings
      instance
    end

    def call
      Consumers::Commands.start('registration:command', settings: settings)
      Consumers::Events.start('registration', settings: settings)

      Consumers::PlayerEmailAddress::Events.start('playerEmailAddress', correlation: 'registration', settings: settings)
    end
  end
end
