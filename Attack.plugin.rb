module Attack
  Priority = 0
  Description = "Comic genius"

  class Plugin
    def initialize(bot)
      @bot = bot
    end
  
    def handle_privmsg(e)
      to = e.params[0]
      if (to != @bot.nick) then
        from = e.nick
        msg = e.params[1]
        if (msg =~ /\A#{@bot.nick}[,:] attack (.+)[.!]*\Z/i) then
          @bot.connection.ctcp_action to, "punches #{from} in the face."
        end
      end
    end
  end
end
