module Replace
  Priority = 0
  Description = "Autoreplace"
  class Plugin
    def initialize(bot)
      @bot = bot
      @bot.class.class_eval {
        attr_accessor :s
      }
      begin
        File.open('s.json', 'r') {|f| @bot.s = JSON.load(f.read)}
      rescue Errno::ENOENT
        $stderr.puts "Failed to load s."
      end
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      if @bot.plugin_loaded? Suppressor then
        if @bot.call_on_plugin(Suppressor, :suppressed, :s) then
          @bot.call_on_plugin(Suppressor, :unsuppress, :s)
          return
        end
      end
      to = e.params[0]
      msg = e.params[1]
      if (to == @bot.nick) then
        if (msg =~ /\A!s (.+) : (.+)\Z/) then
          if (!@bot.s or @bot.s.class != Hash) then
            @bot.s = Hash.new
          end
          @bot.s[$1] = $2
          File.open('s.json', 'w') {|f| f.write(JSON.dump(@bot.s))}
        elsif (@bot.s and msg =~ /\A!f (.+)\Z/) then
          @bot.s.delete($1)
          File.open('s.json', 'w') {|f| f.write(JSON.dump(@bot.s))}
        elsif (@bot.s and msg == "!s_list") then
          @bot.s.keys.each {|k|
            @bot.connection.notice e.from.split('!')[0], "["+k+"] "+@bot.s[k]
          }
        end
      elsif (@bot.s and rand(10) == 1) then
        sub = msg.clone
        @bot.s.keys.each {|k|
          if (msg.include? k) then
            sub.gsub! k, @bot.s[k]
          end
        }
        if (sub != msg) then
          @bot.connection.privmsg to, sub
        end
      end
    end
  end
end
