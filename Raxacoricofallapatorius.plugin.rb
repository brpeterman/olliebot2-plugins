# Wikibot plugin module
module Raxacoricofallapatorius
  Priority = 0
  Description = "Corrects the spelling of Clom's sister planet"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
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
