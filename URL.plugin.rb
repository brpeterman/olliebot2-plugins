require 'htmlentities'
require 'net/http'

module URL
  Priority = 0
  Description = "Returns the titles of any linked web pages"
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def fetch(uri, limit)
      return nil if (limit == 0)
      http = Net::HTTP.new(URI.parse(uri).host, URI.parse(uri).port)
      http.open_timeout = 10
      http.read_timeout = 10
      http.start {|http|
        path = ( URI.parse(uri).request_uri.length > 0 ? URI.parse(uri).request_uri : "/" )
        response = http.request_get(path)
        case response
          when Net::HTTPSuccess then
            return response.body
            #http.get(path) {|str| body << str}
            #body.to_s
          when Net::HTTPRedirection then
            fetch(response['location'], limit-1)
          else nil
        end
      }
      return nil
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      msg = e.params[1]
      if (msg =~ /https?:\/\/[^\s]+/) then
        links = msg.scan(/https?:\/\/[^\s]+/).flatten
        links.each {|url|
          data = fetch(url, 10)
          if (data and data =~ /<title>\s*(.+?)\s*<\/title>/im) then
            coder = HTMLEntities.new
            title = coder.decode($1.gsub(/[\n\r]/," ").strip)
            if (e.params[0] != @bot.nick) then
              @bot.connection.privmsg e.params[0], "\""+title+"\""
            else
              @bot.connection.privmsg e.nick, "\""+title+"\""
            end
          end
        }
      end
    end
  end
end
