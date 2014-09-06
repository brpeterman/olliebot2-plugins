module DieDieDie
  Priority = 0
  Description = "Uses fire as a weapon"
  class Plugin
    def initialize(bot)
      @bot = bot
      bot.class.class_eval {
        attr_accessor :barrier, :names
      }
    end
    
    def handle_privmsg(e)
      msg = e.params[1]
      chan = e.params[0]
      if (msg.index(/diediedie/i)) then
        if (!@bot.barrier) then
          @bot.barrier = {}
        end
        @bot.barrier["namreply-" + chan] = true
        start = Time.now.to_i
        @bot.connection.names(chan)
        while (@bot.barrier["namreply-" + chan] and (Time.now.to_i - start < 10)) do end
        if (@bot.names[chan]) then
          victim = @bot.names[chan][rand(@bot.names[chan].length)]
          if (rand(5) != 1) then
            @bot.connection.ctcp_action chan, "kills "+victim+" with fire >_<"
          else
            @bot.connection.kick chan, victim, "kills "+victim+" with fire >_<"
          end
        else
          @bot.connection.ctcp_action chan, "dies in a fire"
        end
      end
    end
  end
end
