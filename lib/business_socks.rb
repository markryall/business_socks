require 'business_socks/event'
require 'business_socks/fixnum'
require 'business_socks/schedule'
require 'date'

$schedule = BusinessSocks::Schedule.new
$schedule.events << BusinessSocks::Event.new("first event", 10.minutes)
$schedule.events << BusinessSocks::Event.new("break", 5.minutes)

Shoes.app(:title => "Scheduler", :height => 200, :width => 300, :resizeable => false) do
  background "#548898".."#3d6976"
  @state = :not_running
  @start = Time.now.usec

  stack :margin => 10 do
    @timer = title "00:00:00", :align => "center", :stroke => "#a0b8be"
  end

  stack :margin => 10 do
    @title = title "current talk", :align => "center", :stroke => "#a0b8be"
  end

  stack :margin => 10 do
    title @title.methods.sort.join(',')
  end

  count = 0
  animate(1) do
    @now = DateTime.now
    if @state == :not_running 
      #@current = $schedule.events.shift
      @state = :running
    end
    count += 1
    @title.replace count
  end
end