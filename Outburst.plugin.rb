# Wikibot plugin module
module Outburst
  Priority = 0
  Description = "Say something silly"

  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if (!@bot.suppressor[:outburst]) then
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
      else
        @bot.suppressor[:outburst] = false
      end
    end
  end
end
