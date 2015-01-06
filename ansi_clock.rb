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
  class Clock
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

        show
      end
    end

    def inactivate()
      @update_thread.kill
      @update_thread.join
      
      puts Code.restore << Code.cursor_show
      # p Thread::list.size #=> 1
    end

    protected
    def show
      puts Code.clear_screen
      puts Code.cursor_top << "#{@time}"
    end
  end

  class DigiClock < Clock
    protected
    def show
      puts to_string
    end

    private
    def to_string
      to_s_f02d = -> (n) { "#{n}".length == 2 ? "#{n}" : "0#{n}" }
      
      hour   = to_s_f02d.call @time.hour
      min    = to_s_f02d.call @time.min
      sec    = to_s_f02d.call @time.sec
      spacer = " : "
      
      return hour << spacer << min << spacer << sec
    end
  end
end

