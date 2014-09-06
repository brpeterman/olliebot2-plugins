module Blanks
  Priority = 100
  Description = "Replaces underscores with words it knows"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      if (to != @bot.nick and @bot.messages) then
        msg = e.params[1]
        if (msg =~ /\b___+\b/ and !(msg =~ /\A___+\Z/)) then
          list = []
          @bot.messages.each {|m|
            if (!m.include? ' ' and m =~ /\A[\w\-]+\Z/) then
              list << m.downcase.gsub(/[.?,!]/, '')
            end
          }
          while (msg =~ /\b___+\b/) do
            msg.sub!(/\b___+\b/, list[rand(list.length)])
          end
          @bot.connection.privmsg to, msg
        end
      end
    end
  end
end
