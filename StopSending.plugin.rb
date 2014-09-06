module StopSending
  Priority = 999
  Description = "Stops flooding"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if (e.params[1] == "!int") then
        @bot.connection.interrupt
      end
    end
  end
end
