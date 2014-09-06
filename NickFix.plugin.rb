module NickFix
  Priority = 0
  Description = "Make sure we have the right nick"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_nick(e)
      from = e.nick
      newnick = e.params[0]
      @bot.nick = newnick if (from == @bot.nick)
    end
  end
end
