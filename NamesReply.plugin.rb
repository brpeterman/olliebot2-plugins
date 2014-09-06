module NamesReply
  Priority = 0
  Description = "Stores names from NAMES reply and takes down the NAMES barrier"
  class Plugin
    def initialize(bot)
      @bot = bot
      bot.class.class_eval {
        attr_accessor :names, :barrier
      }
    end
    
    def handle_namreply(e)
      if (!@bot.names) then
        @bot.names = {}
      end
      chan = e.params[2]
      names = []
      e.params[3].split(' ').each {|n|
        names << n.sub(/[~@&+%]/, '')
      }
      names.delete(@bot.nick)
      @bot.names[chan] = names
      if (!@bot.barrier) then
        @bot.barrier = {}
      end
      @bot.barrier["namreply-" + chan] = nil
    end
  end
end
