require 'json'

module Lists
  Priority = 90
  Description = "Keeps lists of anything you like, and will tell you them if you ask"
  class Plugin
    def initialize(bot)
      @bot = bot
      @bot.class.class_eval {
        attr_accessor :lists, :properties, :score
      }
      begin
        @bot.lists = {}
        @bot.properties = {}
        @bot.score = {}
        File.open('lists.json', 'r') {|f| @bot.lists = JSON.parse(f.read)}
        File.open('properties.json', 'r') {|f| @bot.properties = JSON.parse(f.read)}
        File.open('scores.json', 'r') {|f| @bot.score = JSON.parse(f.read)}
      rescue Errno::ENOENT
        $stderr.puts "Failed to load lists."
      end
    end
    
    def handle_privmsg(e)
      to = e.params[0]
      if (!(to == @bot.nick)) then
        msg = e.params[1]
        if (msg =~ /\A#{@bot.nick}[,:] add (.+?) to (.+)\.?\Z/i) then
          @bot.suppressor[:herald] = true
          @bot.suppressor[:trigger] = true
          @bot.suppressor[:s] = true
          @bot.suppressor[:outburst] = true
          @bot.suppressor[:decider] = true
          obj = $1.downcase
          list = $2.downcase
          if (list[list.length-1] == "."[0]) then
            list = list[0..list.length-2]
          end
          if (!@bot.lists[list]) then
            @bot.lists[list] = []
          end
          if (!@bot.lists[list].include? obj) then
            @bot.lists[list] << obj
            File.open('lists.json', 'w') {|f| f.write(JSON.dump(@bot.lists))}
            @bot.connection.privmsg to, "#{obj} added to #{list}"
          end
        elsif (msg =~ /\A#{@bot.nick}[,:] remove (.+?) from (.+)\.?\Z/i) then
          @bot.suppressor[:herald] = true
          @bot.suppressor[:trigger] = true
          @bot.suppressor[:s] = true
          @bot.suppressor[:outburst] = true
          @bot.suppressor[:decider] = true
          obj = $1.downcase
          list = $2.downcase
          if (list[list.length-1] == "."[0]) then
            list = list[0..list.length-2]
          end
          if (!@bot.lists[list]) then
            @bot.lists[list] = []
          end
          if (@bot.lists[list].include? obj) then
            @bot.lists[list].delete(obj)
            File.open('lists.json', 'w') {|f| f.write(JSON.dump(@bot.lists))}
            @bot.connection.privmsg to, "#{obj} removed from #{list}"
          end
        elsif (msg =~ /\A#{@bot.nick}[,:] (tell|show) me (.+)\.?\Z/i) then
          @bot.suppressor[:herald] = true
          @bot.suppressor[:trigger] = true
          @bot.suppressor[:s] = true
          @bot.suppressor[:outburst] = true
          @bot.suppressor[:decider] = true
          list = $2.downcase
          if (list[list.length-1] == "."[0]) then
            list = list[0..list.length-2]
          end
          if (!@bot.lists[list]) then
            @bot.lists[list] = []
          end
          if (@bot.lists[list].length == 0) then
            @bot.connection.privmsg to, "I don't know anything like that."
          else
            @bot.connection.privmsg to, list+":"
            @bot.lists[list].each {|i|
              @bot.connection.privmsg to, i
            }
          end
        elsif (msg =~ /([^ ]+) is ([^.,?!]+)/i) then
          nick = $1.downcase
          desc = $2.downcase
          if (!@bot.barrier) then
            @bot.barrier = Hash.new
          end
          @bot.barrier[to] = true
          start = Time.now.to_i
          @bot.connection.names(to)
          while (@bot.barrier[to] and (Time.now.to_i - start < 10)) do end
          if (@bot.names[to]) then
            user = nil
            @bot.names[to].each{|n| user = true if(n.downcase == nick)}
            if (user) then
              @bot.suppressor[:herald] = true
              @bot.suppressor[:trigger] = true
              @bot.suppressor[:s] = true
              @bot.suppressor[:outburst] = true
              @bot.suppressor[:decider] = true
              if (!@bot.properties) then
                @bot.properties = {}
              end
              if (!@bot.properties[nick]) then
                @bot.properties[nick] = []
              end
              @bot.properties[nick] << desc if(!@bot.properties[nick].include? desc)
              File.open("properties.json", "w"){|f| f.write(JSON.dump(@bot.properties))}
            end
          end
        elsif (msg =~ /([^ ]+) isn't ([^.,?!]+)/i) then
          nick = $1.downcase
          desc = $2.downcase
          if (!@bot.barrier) then
            @bot.barrier = Hash.new
          end
          @bot.barrier[to] = true
          start = Time.now.to_i
          @bot.connection.names(to)
          while (@bot.barrier[to] and (Time.now.to_i - start < 10)) do end
          if (@bot.names[to]) then
            user = nil
            @bot.names[to].each{|n| user = true if(n.downcase == nick)}
            if (user) then
              @bot.suppressor[:herald] = true
              @bot.suppressor[:trigger] = true
              @bot.suppressor[:s] = true
              @bot.suppressor[:outburst] = true
              @bot.suppressor[:decider] = true
              if (!@bot.properties) then
                @bot.properties = {}
              end
              if (!@bot.properties[nick]) then
                @bot.properties[nick] = []
              end
              @bot.properties[nick].delete(desc)
              File.open("properties.json", "w"){|f| f.write(JSON.dump(@bot.properties))}
            end
          end
      elsif (msg =~ /\Atell me( all)? about ([^ .]+)\Z/i) then
        nick = $2.downcase
        @bot.suppressor[:herald] = true
        @bot.suppressor[:trigger] = true
        @bot.suppressor[:s] = true
        @bot.suppressor[:outburst] = true
        @bot.suppressor[:decider] = true
          if (@bot.properties[nick].length > 5 and $1 == nil) then
            chosen = []
            while (chosen.length < 5) do
              prop = @bot.properties[nick][rand(@bot.properties[nick].length)];
              if (!chosen.include? prop) then
                chosen.push prop
              end
            end
            @bot.connection.privmsg to, nick+" is..."
            chosen.each {|p|
              @bot.connection.privmsg to, p
            }
          else
            if (@bot.properties[nick] and @bot.properties[nick].length > 0) then
              @bot.connection.privmsg to, nick+" is..."
              @bot.properties[nick].each {|p|
                @bot.connection.privmsg to, p
              }
            end
          end
        elsif msg =~ /^!(.+?)(\+\+|--)?$/
          subject = $1.downcase
          change = $2
          @bot.score = {} if !@bot.score
          @bot.score[subject] = 0 if !@bot.score[subject]
          case change
          when "++"
            @bot.score[subject] += 1
            File.open("scores.json", "w"){|f| f.write(JSON.dump(@bot.score))}
          when "--"
            @bot.score[subject] -= 1
            File.open("scores.json", "w"){|f| f.write(JSON.dump(@bot.score))}
          end
          @bot.connection.privmsg to, subject + ": " + @bot.score[subject].to_s
        end
      end
    end
  end
end
