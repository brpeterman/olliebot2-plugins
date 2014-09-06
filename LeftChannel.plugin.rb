module LeftChannel
  Priority = 0
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_kick(e)
      if (e.params[1] == @bot.nick) then
        @bot.chans.delete(e.params[0])
        @bot.chans.uniq!
      end
    end
    
    def handle_part(e)
      if (e.nick == @bot.nick) then
        @bot.chans.delete(e.params[0])
        @bot.chans.uniq!
      end
    end
  end
end
