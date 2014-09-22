# Wikibot plugin module
module Stalker
  Priority = 0
  class Plugin
    def initialize(bot)
      @bot = bot
      @bot.class.class_eval {
        attr_accessor :stalking
      }
      @bot.stalking = {}
    end
  
    def handle_nick(e)
      oldnick = e.nick
      newnick = e.params[0]
      if (@bot.stalking[oldnick]) then
        @bot.stalking[oldnick] = nil
        @bot.stalking[newnick] = true
      end
    end
    
    def handle_ctcp_action(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      from = e.nick
      msg = e.params[1]
      if (to != @bot.nick) then
        if (@bot.stalking[from]) then
          @bot.connection.ctcp_action to, msg.gsub(/#{@bot.nick}/i, from)
        end
      end
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      from = e.nick
      msg = e.params[1]
      if (to == @bot.nick) then
        command = msg.split(' ', 3)
        if (command[0] == '!stalk') then
          if (command[1] == 'start') then
            @bot.stalking[command[2]] = true
          elsif (command[1] == 'stop') then
            @bot.stalking[command[2]] = nil
          end
        end
      elsif (to != @bot.nick) then
        if (@bot.stalking[from]) then
          @bot.connection.privmsg to, msg.gsub(/#{@bot.nick}/i, from)
        end
      end
    end
  end
end
