module Echo
  Priority = 0

  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(event)
      #$stderr.puts event
      to = event.params[0]
      dest = to
      if to == @bot.nick then
        dest = event.nick
      end
      @bot.connection.privmsg dest, event.params[1]
    end
  end
end