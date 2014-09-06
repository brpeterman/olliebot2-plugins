require 'json'

module Trigger
  Priority = 0
  
  class Plugin
    def initialize(bot)
      @bot = bot
      @bot.class.class_eval {
        attr_accessor :triggers
      }
      begin
        File.open('triggers.json', 'r') {|f| @bot.triggers = JSON.load(f.read)}
      rescue Errno::ENOENT
        $stderr.puts "Failed to load triggers."
      end
    end
    
    def handle_privmsg(e)
      if (!@bot.suppressor[:trigger]) then
        to = e.params[0]
        if (to == @bot.nick) then
          from = e.nick
          msg = e.params[1]
          if (msg =~ /!trigger (.+) : (.+)/) then
            trigger = $1.strip
            reaction = $2.strip
            if (!@bot.triggers) then
              @bot.triggers = Hash.new
            end
            @bot.triggers[trigger] = reaction
            trig_data = JSON.dump(@bot.triggers)
            File.open('triggers.json', 'w') {|f| f.write(trig_data)}
            @bot.connection.notice from, "Trigger '"+trigger+"' added."
          elsif (msg =~ /!untrigger (.+)/) then
            trigger = $1.strip
            if (!@bot.triggers) then
              @bot.connection.notice from, "No triggers exist."
            elsif (!@bot.triggers[trigger]) then
              @bot.connection.notice from, "No trigger '"+trigger+"' exists."
            else
              @bot.triggers.delete(trigger)
              trig_data = Marshal.dump(@bot.triggers)
              File.open('triggers.json', 'w') {|f| f.write(trig_data)}
              @bot.connection.notice from, "Trigger '"+trigger+"' removed."
            end
          elsif (msg == '!trig_list') then
            if (@bot.triggers) then
              @bot.triggers.keys.each {|k|
                @bot.connection.notice from, "["+k+"] "+@bot.triggers[k]
              }
            else
              @bot.connection.notice from, "No triggers registered."
            end
          end
        else
          if (@bot.triggers) then
            msg = e.params[1]
            @bot.triggers.keys.each {|k|
              l = Regexp.escape(k)
              if (msg =~ /\b#{l}\b/i) then
                @bot.suppressor[:herald] = true
                sleep 1
                @bot.triggers[k].split('\n').each {|part|
                  @bot.connection.privmsg to, part
                }
              end
            }
          end
        end
      else
        @bot.suppressor[:triggers] = false
      end
    end
  end
end
