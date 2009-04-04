class ::Fixnum
  def seconds
    self
  end
  
  def second
    self.seconds
  end
  
  def minutes
    self * 60
  end
  
  def minute
    self.minutes
  end
end