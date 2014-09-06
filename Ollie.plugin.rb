# Wikibot plugin module
module Ollie
  Priority = 0
  Description = "Nickserv identification"
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_endofmotd(e)
      @bot.connection.nick 'OllieBot'
      @bot.connection.privmsg 'nickserv', "identify s3cr3tp4assw0rd"
      @bot.nick = 'OllieBot'
    end
  end
end
