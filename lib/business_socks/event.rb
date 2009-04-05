module BusinessSocks
  Event = Struct.new(:description, :duration, :presenter)
  
  class Event
    def start
      @started_time = Time.now
    end

    def finish_time
      @started_time + duration if self.started?
    end

    def started?
      @started_time
    end

    def finished?
      self.started? and Time.now > self.finish_time
    end
    
    def elapsed
      self.started? ? Time.now - @started_time : 0
    end
    
    def remaining
      self.started? ? self.finish_time - Time.now : self.duration
    end
    
    def stage(number=nil)
      return 0 unless self.started?
      proportion = self.elapsed/self.duration
      proportion = 0 if proportion < 0
      proportion = 1 if proportion > 1
      number ? (proportion*number).to_i : proportion
    end
  end
end