module AutoJoin
  Priority = 0
  Channels = ['#!/bin/sh']
  
  class Plugin
    def initialize(bot)
      @bot = bot
    end
    
    def handle_endofmotd(event)
      AutoJoin::Channels.each do |channel|
        @bot.connection.join channel
      end
    end
  end
end