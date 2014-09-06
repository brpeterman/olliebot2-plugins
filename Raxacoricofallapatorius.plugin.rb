# Wikibot plugin module
module Raxacoricofallapatorius
  Priority = 0
  Description = "Corrects the spelling of Clom's sister planet"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      if (to != @bot.nick) then
        msg = e.params[1]
        if (!msg.downcase.index("raxacoricofallapatorius") and msg =~ /\brax[A-Za-z]+coric[A-Za-z]+ius\b/i) then
          sleep 1
          @bot.connection.privmsg to, "*Raxacoricofallapatorius"
        end
      end
    end
  end
end
