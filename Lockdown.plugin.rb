module Lockdown
  Priority = 0
  Description = "Only accept messages from registered nicks"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_endofmotd(e)
      @bot.connection.mode @bot.nick, '+R'
    end
  end
end
