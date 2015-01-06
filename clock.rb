#!/usr/bin/env ruby
# encoding: utf-8

require './ansi_clock'

clock = Ansi::Clock.new

begin
  clock.activate 
rescue Interrupt
  puts "Exiting..."

  clock.inactivate

  p Thread::list.size #=> 1
end
