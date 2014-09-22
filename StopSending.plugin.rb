module StopSending
  Priority = 999
  Description = "Stops flooding"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      if (e.params[1] == "!int") then
        @bot.connection.interrupt
      end
    end
  end
end
