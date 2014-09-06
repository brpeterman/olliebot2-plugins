# Wikibot plugin module
module JoinPartQuitNick
  Priority = 0
  Description = "Puppet commands for joining, parting, quitting, and changing nick"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      msg = e.params[1]
      from = e.nick
      chan = msg.split(' ')[1]
      if (to == @bot.nick) then
        if (msg.index('!join') == 0) then
          if (chan) then
            @bot.connection.join chan
          end
        elsif (msg.index('!part') == 0) then
          if (chan) then
            @bot.connection.part chan
          end
        elsif (msg.index('!quit') == 0) then
          line = "Goodbye!"
          if (msg.split(' ', 2)[1]) then
            line = msg.split(' ', 2)[1]
          end
          @bot.connection.quit(line)
        elsif (msg.index('!nick') == 0) then
          @bot.connection.nick chan
        end
      end
    end
  end
end
