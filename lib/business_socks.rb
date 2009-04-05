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
    @para_time = para Time.now.strftime('%H:%M:%S'), :size => 210, :align => "center", :stroke => "#a0b8be"
    @para_timer = para "", :stroke => "#a0b8be"
    @para_description = para "", :size => 50, :align => "center", :stroke => "#a0b8be"
    @command = title "", :align => "center", :stroke => "#a0b8be"
  end

  def change_state new_state
    debug "state transition from #{@state} to #{new_state}"
    @state = new_state
  end

  def clear
    @para_description.replace ""
    @para_timer.replace ""
    change_state :not_running
  end

  animate(2) do
    @para_time.replace Time.now.strftime('%H:%M:%S')
    case @state
      when :timing:
      new_time = @midnight + (Time.now - @start)
      @para_timer.replace new_time.strftime('%H:%M:%S')
      when :schedule:
      if @schedule.current
        new_time = @midnight + @schedule.current.remaining
        color = yellow
        color = orange if @schedule.current.remaining < (@schedule.current.duration*2/3)
        color = red if @schedule.current.remaining < (@schedule.current.duration/3)
        @para_description.replace strong(@schedule.current.description, :stroke=>gray), strong(@schedule.current.presenter, :stroke=>blue)
        @para_timer.replace new_time.strftime('%H:%M:%S'), :stroke=>color, :size => 150, :align => "center"
      else
        clear
      end
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