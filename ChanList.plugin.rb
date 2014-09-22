module ChanList
  Priority = 0
  Description = "Replies with a list of channels currently occupied"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      if (e.params[1] == "!channel_list") then
        @bot.connection.notice e.nick, @bot.chans.join(', ')
      end
    end
  end
end
