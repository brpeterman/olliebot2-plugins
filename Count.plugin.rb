module Count
  Priority = 0
  Description = "Notify how many phrases and actions it knows"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      from = e.nick
      msg = e.params[1]
      if (to == @bot.nick and msg == '!count') then
        @bot.connection.notice from, "Stored messages: "+(bot.messages.length+1).to_s
        @bot.connection.notice from, "Stored actions: "+(bot.actions.length+1).to_s
      end
    end
  end
end
