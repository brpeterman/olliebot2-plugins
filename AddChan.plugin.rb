# Wikibot plugin module
module AddChan
  Priority = 0
  Description = "Note if joined a channel"
  
  class Plugin
    def initialize(bot)
      @bot = bot
      bot.class.class_eval { attr_accessor :chans }
      bot.chans = []
    end
    
    def handle_join(e)
      if (e.nick == @bot.nick) then
        @bot.chans << e.params[0]
        @bot.chans.uniq!
      end
    end
  end
end
