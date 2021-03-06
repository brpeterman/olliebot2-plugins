# Wikibot plugin module
module BandName
  Priority = 5
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      if (to != @bot.nick) then
        msg = e.params[1]
        if (msg =~ /([A-Z]([a-z'\-])+ [A-Z]([a-z'\-])+( [A-Z]([a-z'\-])+)+)/) then
          if (rand(3) == 1) then
            @bot.call_on_plugin(Suppressor, :suppress, :trigger, :herald)
            @bot.connection.privmsg to, "\""+$1+"\" would be a good name for a"+(" rock"*rand(2))+" band."
          end
        elsif (msg =~ /\A([A-Z]+ [A-Z]+ [A-Z]+)\Z/) then
          name = $1.downcase
          name.gsub!(/\b\w/){$&.upcase}
          if (rand(3) == 1) then
            @bot.call_on_plugin(Suppressor, :suppress, :trigger, :herald)
            @bot.connection.privmsg to, "\""+name+"\" would be a good name for a"+(" rock"*rand(2))+" band."
          end
        end
      end
    end
  end
end
