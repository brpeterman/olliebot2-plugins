module Creepy
  Priority = 0
  Description = "CREEPY PERSON"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      msg = e.params[1]
      from = e.nick
      if (to == @bot.nick && from == "Eggbot") then
        @bot.connection.privmsg "#tkz/minecraft", "halp! a creepy ugly person is talking to me!"
      end
    end
  end
end
