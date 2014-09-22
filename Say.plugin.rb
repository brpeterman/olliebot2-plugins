# Wikibot plugin module
module Say
  Priority = 0
  Description = "Puppet plugin"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      msg = e.params[1]
      from = e.nick
      parts = msg.split(' ', 3)
      if (to == @bot.nick) then
        if (parts[0] == "!say") then
          @bot.connection.privmsg parts[1], parts[2]
        end
      end
    end
  end
end
