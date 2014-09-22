# Wikibot plugin module
module LuffLuffLuff
  Priority = 0
  Description = "luffs the shit out of things"
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
      if (msg.index(/luffluffluff/i)) then
        if (!@bot.barrier) then
          @bot.barrier = Hash.new
        end
        @bot.barrier["namreply-" + chan] = true
        start = Time.now.to_i
        @bot.connection.names(chan)
        Thread.start do
          while (@bot.barrier["namreply-" + chan] and (Time.now.to_i - start < 10)) do end
          if (@bot.names[chan]) then
            victim = @bot.names[chan][rand(@bot.names[chan].length)]
            if (rand(6) != 1) then
              @bot.connection.ctcp_action chan, "luffs "+victim+" a lot <3"
            else
              @bot.connection.kick chan, victim, "luffs "+victim+" too much :o"
            end
          else
            @bot.connection.ctcp_action chan, "luffs all night long"
          end
        end
      end
    end
  end
end
