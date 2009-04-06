module BusinessSocks
  Schedule = Struct.new(:events)
  
  class Schedule
    def initialize
      self.events = []
    end

    def event *args
      self.events << Event.new(*args)
    end
    
    def kill_one
      @current = nil
    end
    
    def kill
      self.events = []
      @current = nil
    end
    
    def current
      if !@current or @current.finished?
        @current = self.events.shift
        @current.start if @current
      end
      @current
    end
  end
end