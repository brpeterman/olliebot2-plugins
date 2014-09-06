# Wiki@bot plugin module
module Greetings
  Priority = 10
  Description = "Respond to greetings and answer who and where questions"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
  
    def handle_privmsg(e)
      to = e.params[0]
      msg = e.params[1]
      from = e.nick
      dest = to
      if (to == @bot.nick) then
        dest = from
      end
      if (msg =~ /\bwho are you\b/i) then
        @bot.suppressor[:herald] = true
        sleep 1
        @bot.connection.privmsg dest, "I'm "+@bot.nick+"!"
      elsif (msg =~ /\bwhere are you\b/i) then
        @bot.suppressor[:herald] = true
        sleep 1
        line = "I'm in "
        if (@bot.chans.length == 1) then
          line += @bot.chans[0]
        elsif (@bot.chans.length == 2) then
          line += @bot.chans[0]+" and "+@bot.chans[1]
        else
          (0..@bot.chans.length-2).each {|i|
            line += @bot.chans[i]+", "
          }
          line += "and "+@bot.chans[@bot.chans.length-1]
        end
        @bot.connection.privmsg dest, line
      elsif (msg =~ /(hi|hello|hey|sup),? (#{@bot.nick}|ollie)/i and from != "Heraldbot" and from != "superluffly") then
              @bot.suppressor[:herald] = true
        sleep 1
        @bot.connection.privmsg dest, "Hi "+from
      end
    end
  end
end
