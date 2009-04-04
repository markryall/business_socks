module BusinessSocks
  Event = Struct.new(:description, :duration, :presenter)
  
  class Event
    def start
      @finish_time = Time.now + self.duration
    end

    def finished?
      Time.now > @finish_time
    end
    
    def remaining
      @finish_time - Time.now
    end
  end
end