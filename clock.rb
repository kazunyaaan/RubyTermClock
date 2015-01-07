#!/usr/bin/env ruby
# encoding: utf-8

require './ansi_clock'

clock = Ansi::Clock.new

begin
  clock.activate 
rescue Interrupt
  clock.inactivate
end
