module Bucket
  Priority = 0
  
  class Plugin
    def initialize(bot)
      @bot = bot
      bot.class.class_eval {
        attr_accessor :bucket
      }
    end
    
    def handle_ctcp_action(e)
      to = e.params[0]
      if (to != @bot.nick) then
        msg = e.params[1]
        from = e.nick
        if (msg =~ /^gives #{@bot.nick} (.+)[\.\?\!]?/i) then
          @bot.suppressor[:herald] = true
          item = $1
          if (!@bot.bucket) then
            begin
              File.open("bucket.txt") {|f| @bot.bucket = f.readlines.to_s}
            rescue Errno::ENOENT
              @bot.bucket = "a fish"
            end
          end
          File.open("bucket.txt", "w") {|f| f.print item}
          out = ""
          if (rand(2) == 1) then
            out = "takes #{item} and gives #{from} #{@bot.bucket}"
          else
            out = "is now carrying #{item}, but dropped #{@bot.bucket}"
          end
          @bot.connection.ctcp_action(to, out)
          @bot.bucket = item
        end
      end
    end
  end
end
