module ICanHas
  Priority = 0
  Description = "Grant requests"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      msg = e.params[1]
      chan = e.params[0]
      from = e.nick
      if(msg.index(/\A(i can( plz)? ha[sz]) (.+)/i)) then
        noun = $3.downcase.sub(/(plz)?\?/, '')
        if (noun.downcase == 'cheezburger' or noun.downcase == 'hug') then
          noun = "a "+noun
        end
        @bot.connection.ctcp_action chan, "gives "+from+" "+noun
      end
    end
  end
end
