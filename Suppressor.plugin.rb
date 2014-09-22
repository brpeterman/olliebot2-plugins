# Wikibot plugin module
module Suppressor
  Priority = 1000
  Description = "Sets up the suppressor"
  class Plugin
    def initialize(bot)
      @bot = bot
      bot.class.class_eval {
        attr_accessor :suppressor
      }
      bot.suppressor = {}
    end
    
    def suppressed(flag)
      if @bot.suppressor[flag] then
        true
      else
        false
      end
    end
    
    def suppress(*flags)
      flags.each do |flag|
        @bot.suppressor[flag] = true
      end
    end
    
    def unsuppress(*flags)
      flags.each do |flag|
        @bot.suppressor[flag] = nil
      end
    end
  end
end
