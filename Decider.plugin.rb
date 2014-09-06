module Decider
  Priority = 80
  Description = "Given a choice of things, will choose one of them"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      if (to != @bot.nick) then
        msg = e.params[1]
        from = e.nick
        if (msg =~ /#{@bot.nick}[,:] ((.+) or ([^?]+))\??/i) then
          @bot.suppressor[:herald] = true
          @bot.suppressor[:trigger] = true
          @bot.suppressor[:s] = true
          @bot.suppressor[:outburst] = true
          opts = $1.split(' or ')
          choice = opts[rand(opts.length)]
          @bot.connection.privmsg to, from+": "+choice
        end
      end
    end
  end
end
