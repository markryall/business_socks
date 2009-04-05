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
    @para_time = para Time.now.strftime('%H:%M'), :size => 210, :align => "center", :stroke => "#a0b8be"
    @para_timer = para "", :stroke => "#a0b8be"
    @para_description = para "", :size => 50, :align => "center", :stroke => "#a0b8be"
    @videos << video('bicycle1.mp3')
    @videos << video('bicycle2.mp3')
    @videos << video('bicycle3.mp3')
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

  def stage_transition? properties
    @old_stage == properties[:from] and @new_stage == properties[:to]
  end

  colors = [yellow, orange, red]

  animate(2) do
    @para_time.replace Time.now.strftime('%H:%M')
    case @state
      when :timing:
      new_time = @midnight + (Time.now - @start)
      @para_timer.replace new_time.strftime('%H:%M:%S')
      when :schedule:
      if @schedule.current
        new_time = @midnight + @schedule.current.remaining
        @new_stage = @schedule.current.stage(3)
        @videos[0].play if stage_transition? :from => 0, :to => 1
        @videos[1].play if stage_transition? :from => 1, :to => 2
        @videos[2].play if stage_transition? :from => 2, :to => 0
        @old_stage = @new_stage
        @para_description.replace strong(@schedule.current.description, :stroke=>gray), strong(@schedule.current.presenter, :stroke=>blue)
        @para_timer.replace new_time.strftime('%H:%M:%S'), :stroke=>colors[@new_stage], :size => 150, :align => "center"
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
        @schedule.current.duration = 1 if @schedule and @schedule.current
      when '+':
        @schedule.current.duration += 60 if @schedule and @schedule.current
      when '-':
        @schedule.current.duration -= 60 if @schedule and @schedule.current
    end
  end
end