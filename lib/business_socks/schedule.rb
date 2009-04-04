module BusinessSocks
  Schedule = Struct.new(:events)
  
  class Schedule
    def initialize
      self.events = []
    end
  end
end