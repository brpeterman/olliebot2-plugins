# Wikibot plugin module
module Analogy
  Priority = 0
  
  class Plugin
    def initialize(bot)
      require 'net/http'
      require 'cgi'
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      if (e.params[1] =~ /(.+) is to (.+) as(\.+|:)/) then
        http = Net::HTTP.new("www.google.com")
        query = CGI::escape($1 + " is to " + $2 + " as * is to *")
        resp = http.get("/search?q=\""+query+"\"")
        if (resp.body =~ /<em>#{$1} is to #{$2} as (.+?)[\.\?\!,<]/i) then
          half = $1.gsub(/<\/?em>/, "")
          @bot.connection.privmsg(e.params[0], half)
        else
          @bot.connection.privmsg(e.params[0], "cats are to dogs")
        end
      end
    end
  end
end
