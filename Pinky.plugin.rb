module Pinky
  Priority = 10
  Description = "Suggests nocturnal activities"
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
        if (msg =~ /are you thinking what .{3,10} thinking/i) then
          sleep 1
            resp = ["where are we going to find six midgets and a mime at this time of the night?",
                    "when was the last time a Jack-O-Lantern solved any major problems?",
                    "I don't think Bruce Campbell ever met Princess Di.",
                    "he never gave up the location of the buried treasure before he died.",
                    "but I'm pretty sure you can change a lightbulb by yourself.",
                    "what's Bob Dole got to do with anything?",
                    "how are we going to market a sonic screwdriver in this economy?",
                    "wasn't that just a myth?",
                    "we'd need at least three people in order to kill her.",
                    "an oven that spanks people would probably break numerous health and safety laws.",
                    "I haven't buried the last one yet.",
                    "where are we going to get a tutu that fits Oyerth?"]
            @bot.connection.privmsg to, "I think so, but "+resp[rand(resp.length)]
        elsif (msg =~ /what ((are we (gonna|going to))|(should we)) do/i) then
          sleep 1
          @bot.connection.privmsg to, "The same thing we do every night, "+e.nick+"."
          sleep 0.5
          @bot.connection.privmsg to, "Try to take over the world!"
          @bot.call_on_plugin(Suppressor, :suppress, :herald)
        end
      end
    end
  end
end
