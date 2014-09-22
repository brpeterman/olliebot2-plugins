module Google
  Priority = 0
  Description = "Return the first three results of a Google query"
  class Plugin
    def initialize(bot)
      @bot = bot
      require 'net/http'
      require 'cgi'
      require 'htmlentities'
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      if (to != @bot.nick) then
        msg = e.params[1]
        if (msg =~ /\A\.google (.+)\Z/i) then
          query = CGI::escape($1)
          uri = "http://www.google.com/search?q="+query
          body = []
          http = Net::HTTP.new(URI.parse(uri).host, URI.parse(uri).port)
          http.start {|http|
            path = ( URI.parse(uri).request_uri.length > 0 ? URI.parse(uri).request_uri : "/" )
            http.get(path) {|str| body << str}
          }
          res = []
          coder = HTMLEntities.new
          body.to_s.scan(/<h3 .+?><a href="(.+?)".+?>(.+?)<\/a><\/h3>/) {|s|
            res << [s[0], coder.decode(s[1].gsub(/<\/?[^>]*>/, ""))]
          }
          if (res.length > 0) then
            (1..( res.length < 3 ? res.length : 3 )).each {|i|
                @bot.connection.privmsg to, res[i-1][1] + " - " + res[i-1][0]
            }
          else
            @bot.connection.privmsg to, "No results"
          end
        end
      end
    end
  end
end
