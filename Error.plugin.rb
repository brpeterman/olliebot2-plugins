module Error
  Priority = 0
  Description = "Make sure channel list is empty if disconnected"
  class Plugin
    def initialize(bot)
      @bot = bot
      @bot.class.class_eval { attr_accessor :chans }
    end
    
    def handle_error(e)
      @bot.chans = []
    end
  end
end
