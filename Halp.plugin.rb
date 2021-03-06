module Halp
  Priority = 0
  Description = "Provides halp"
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
      dest = to
      if (to == @bot.nick) then
        dest = from
      end
      if (msg.index(/halp([^s]|\b)/i)) then
        @bot.connection.ctcp_action dest, "halps "+from
      end
    end
  end
end
