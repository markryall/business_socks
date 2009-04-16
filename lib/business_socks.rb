require 'business_socks/event'
require 'business_socks/fixnum'
require 'business_socks/schedule'
require 'time'

Shoes.app(:title => "Business Socks", :height => 800, :width => 1400, :resizeable => false) do
  background black
  @midnight = Time.parse('00:00')
  @state = :not_running
  @start = Time.now.usec
  @videos = []

  stack :margin => 10 do
    @para_timer = para "", :size => 200
    @para_time = para Time.now.strftime('%H:%M'), :size => 150, :align => "center", :stroke => "#a0b8be"
    @para_description = para '', :size => 50, :align => "center"
    @videos << video('bicycle1.mp3', :height => 1, :width => 1)
    @videos << video('bicycle2.mp3', :height => 1, :width => 1)
    @videos << video('foghorn.mp3', :height => 1, :width => 1)
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

  def on_stage_transition properties
    yield if @old_stage == properties[:from] and @new_stage == properties[:to]
  end

  def set_timer time, color="#a0b8be"
    @para_timer.replace time.strftime('%H:%M:%S'), :stroke=>color, :size => 200, :align => "center"
  end

  colors = [yellow, orange, red]

  animate(2) do
    @para_time.replace Time.now.strftime('%H:%M')
    case @state
      when :timing:
      new_time = @midnight + (Time.now - @start)
      set_timer new_time
      when :schedule:
      if @schedule.current
        @para_description.replace strong(@schedule.current.description, :stroke=>gray), strong(@schedule.current.presenter, :stroke=>blue)
        new_time = @midnight + @schedule.current.remaining
        @new_stage = @schedule.current.stage(3)
        on_stage_transition(:from => 0, :to => 1) { @videos[0].play }
        on_stage_transition(:from => 1, :to => 2) { @videos[1].play }
        on_stage_transition(:from => 2, :to => 0) { @videos[2].play }
        @old_stage = @new_stage
        set_timer new_time, colors[@new_stage]
      else
        clear
        @videos[2].play
      end
    end
  end

  keypress do |k|
    case k
      when 's':
        @start = Time.now
        change_state :timing
      when 'S':
        clear
      when 'l':
        if (path = ask_open_file)
          @schedule = BusinessSocks::Schedule.new
          @schedule.instance_eval(File.read(path))
          debug "load schedule with #{@schedule.events.size} events"
          change_state :schedule
        end
      when 'k':
        @schedule.kill_one if @schedule
      when 'K':
        @schedule.kill if @schedule
      when '+':
        @schedule.current.duration += 60 if @schedule and @schedule.current
      when '-':
        @schedule.current.duration -= 60 if @schedule and @schedule.current
    end
  end
end
