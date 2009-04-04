module BusinessSocks
  Schedule = Struct.new(:events)
  
  class Schedule
    def initialize
      self.events = []
    end

    def event *args
      self.events << Event.new(*args)
    end
    
    def current
      unless @current
        @current = self.events.shift
        @current.start if @current
      end
      if @current.finished?
        @current = self.events.shift
        @current.start if @current
      end
      @current
    end
  end
end