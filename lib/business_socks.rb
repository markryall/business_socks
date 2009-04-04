require 'business_socks/event'
require 'business_socks/fixnum'
require 'business_socks/schedule'
require 'time'

Shoes.app(:title => "Business Socks", :height => 800, :width => 1400, :resizeable => false) do
  background black
  @midnight = Time.parse('00:00')
  @state = :not_running
  @start = Time.now.usec

  stack :margin => 10 do
    @now = para Time.now.strftime('%H:%M:%S'), :size => 210, :align => "center", :stroke => "#a0b8be"
    @timer = para "", :size => 150, :align => "center", :stroke => "#a0b8be"
    @description = para "", :size => 100, :align => "center", :stroke => "#a0b8be"
    @command = title "", :align => "center", :stroke => "#a0b8be"
  end

  def change_state new_state
    debug "state transition from #{@state} to #{new_state}"
    @state = new_state
  end

  def clear
    @description.replace ""
    @timer.replace ""
    change_state :not_running
  end

  animate(1) do
    @now.replace Time.now.strftime('%H:%M:%S')
    case @state
      when :timing:
        new_time = @midnight + (Time.now - @start)
        @timer.replace new_time.strftime('%H:%M:%S')
      when :schedule:
        clear unless @schedule.current
        new_time = @midnight + @schedule.current.remaining
        @description.replace @schedule.current.description
        @timer.replace new_time.strftime('%H:%M:%S')
    end
  end

  @buffer = ''
  keypress do |k|
    case k
      when 'a'..'z': @buffer << k
      when 'D': @buffer = ''
      when :backspace: @buffer = @buffer.slice(0...-1)
    end
    case @buffer
      when 'start':
        @buffer = ''
        @start = Time.now
        change_state :timing
      when 'stop':
        @buffer = ''
        clear
      when 'load':
        @buffer = ''
        if (path = ask_open_file)
          @schedule = BusinessSocks::Schedule.new
          @schedule.instance_eval(File.read(path))
          debug "load schedule with #{@schedule.events.size} events"
          change_state :schedule
        end
    end
    @command.replace @buffer
  end
end