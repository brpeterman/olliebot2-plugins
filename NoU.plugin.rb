# Wikibot plugin module
module NoU
  Priority = 0
  Description = "Automagic insult generator"
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
        if (msg =~ /.+('re|'s|\bis|\bare) (an?|the) ([^?]+)/i) then
          if (rand(4) == 1) then
            sleep 1
            @bot.connection.privmsg to, "You're "+$2.downcase+" "+$3.downcase
          end
        end
      end
    end
  end
end
