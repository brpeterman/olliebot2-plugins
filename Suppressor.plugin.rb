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
  end
end
