module BusinessSocks
  Event = Struct.new(:description, :duration)
  
  class Event
    def start
      @start_time = Time.now.usec
      @finish_time = @start_time + self.duration * 1000
    end

    def finished?
      Time.now.usec > @finish_time
    end
    
    def has_started?
      false
    end
  end
end