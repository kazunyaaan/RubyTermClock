require 'term/ansicolor'

class Color
  extend Term::ANSIColor
end

module Code
  extend self
  
  def save
    "\e[?1049h"
  end

  def restore
    "\e[?1049l"
  end

  def cursor_hide
    "\e[?25l"
  end

  def cursor_show
    "\e[?25h"
  end


  def clear_screen
    "\e[2J"
  end

  def clear_line
    "\e[2K"
  end

  def cursor_top
    "\e[H"
  end
end

module Ansi
  class ClockBase
    def activate()
      puts Code.save << Code.cursor_hide
      
      @meg = Queue.new

      @update_thread = Thread.new do
        loop do
          time = Time.now
          @meg.push(time)

          sleep 1.0 - time.usec * 1e-6
        end
      end

      loop do
        @time = @meg.pop

        print Code.clear_screen << Code.cursor_top
        
        show
      end
    end

    def inactivate()
      @update_thread.kill
      @update_thread.join
      
      puts Code.restore << Code.cursor_show
    end

    protected
    def show
      puts "#{@time}"
    end
  end

  class Clock < ClockBase
    protected
    def show
      f = -> (n) { sprintf("%02d", n) }
      h = f.call @time.hour
      m = f.call @time.min
      s = f.call @time.sec

      puts "#{h} : #{m} : #{s}"
    end
  end
end

