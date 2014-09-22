# Wikibot plugin module
module Outburst
  Priority = 0
  Description = "Say something silly"

  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      if @bot.plugin_loaded? Suppressor then
        if @bot.call_on_plugin(Suppressor, :suppressed, :outburst) then
          @bot.call_on_plugin(Suppressor, :unsuppress, :outburst)
          return
        end
      end
      if (rand(300) == 1) then
        to = e.params[0]
        if (to != @bot.nick) then
          if (rand(2) == 1) then
            @bot.connection.privmsg to, "KHA"+("A"*rand(5))+"N!"
          else
            @bot.connection.privmsg to, "EXTERMINATE!"
          end
        end
      end
    end
  end
end
