module Herald
  Priority = 0
  
  class Plugin
    def initialize(bot)
      require 'json'
    
      @bot = bot
      @bot.class.class_eval {
        attr_accessor :messages, :actions, :last_msg, :msg_logger, :act_logger
      }
      begin
        File.open('msg_log.json', 'r') {|f| @bot.messages = JSON.load(f.read)}
        File.open('act_log.json', 'r') {|f| @bot.actions = JSON.load(f.read)}
      rescue Errno::ENOENT => e
        $stderr.puts "Failed to load message log(s):"
        $stderr.puts e.inspect
      end
    end
    
    def handle_privmsg(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      if (to != @bot.nick) then
        # Forget last thing said
        if (e.params[1] =~ /(#{@bot.nick}[,\:]? forget that)|(forget that[,\:]? #{@bot.nick})/i) then
          if (@bot.last_msg) then
            @bot.messages.delete(@bot.last_msg)
            log_data = JSON.generate(@bot.messages)
            File.open('msg_log.json', 'w') {|f| f.write(log_data)}
            @bot.connection.privmsg to, "Forgot \"#{@bot.last_msg}\""
            @bot.last_msg = nil
          else
            @bot.connection.privmsg to, "Forget what?"
          end
        else
          # Speak
          if @bot.plugin_loaded? Suppressor
            if @bot.call_on_plugin(Suppressor, :suppressed, :herald) then
              @bot.call_on_plugin(Suppressor, :unsuppress, :herald)
              return
            end
          end
          if (rand(5) == 1) then
            if (!@bot.messages) then
              @bot.messages = Array.new
            end
            from = e.nick
            msg = e.params[1].clone
            msg.gsub!(/#{@bot.nick}/i, from)
            if (!@bot.messages.index(msg)) then
              $stderr.puts "Adding message '"+msg+"'"
              @bot.messages << msg
              if (!@bot.msg_logger) then
                @bot.msg_logger = lambda {
                  begin
                    log_data = JSON.generate(@bot.messages)
                    File.open('msg_log.json', 'w') {|f| f.write(log_data)}
                  rescue Encoding::UndefinedConversionError
                    @bot.messages.remove msg
                  end
                }
              end
              @bot.msg_logger.call
            end
          end
          if (rand(60) == 1 or e.params[1] =~ /#{@bot.nick}/i) then
            if (@bot.messages) then
              to = e.params[0]
              msg = e.params[1]
              if (to != @bot.nick) then
                sleep 1
                say = @bot.messages[rand(@bot.messages.length)]
                @bot.last_msg = say
                @bot.connection.privmsg to, say
              end
            end
          end
        end
      end
    end

    def handle_ctcp_action(e)
      if @bot.plugin_loaded? IgnoreList then 
        return if @bot.call_on_plugin(IgnoreList, :ignored, e.nick)
      end
      to = e.params[0]
      if (to != @bot.nick) then
        if (rand(2) == 1) then
          if (!@bot.actions) then
            @bot.actions = Array.new
          end
          from = e.nick
          msg = e.params[1]
          msg.gsub!(/#{@bot.nick}/i, from)
          if (!@bot.actions.index(msg)) then
            $stderr.puts "Adding action '"+msg+"'"
            @bot.actions << msg
            if (!@bot.act_logger) then
              begin
                @bot.act_logger = lambda {
                  log_data = JSON.generate(@bot.actions)
                  File.open('act_log.json', 'w') {|f| f.write(log_data)}
                }
              rescue Encoding::UndefinedConversionError
                @bot.actions.remove msg
              end
            end
            @bot.act_logger.call
          end
        end
        if (rand(40) == 1 or e.params[1] =~ /#{@bot.nick}/i) then
          if @bot.plugin_loaded? Suppressor
            if @bot.call_on_plugin(Suppressor, :suppressed, :herald) then
              @bot.call_on_plugin(Suppressor, :unsuppress, :herald)
              return
            end
          end
          if (@bot.actions) then
            to = e.params[0]
            msg = e.params[1]
            sleep 1
            @bot.connection.ctcp_action to, @bot.actions[rand(@bot.actions.length)]
          end
        end
      end
    end
  end
end
