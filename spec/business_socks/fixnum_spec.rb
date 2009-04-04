require File.join(File.dirname(__FILE__), '..', 'spec_helper' )

describe Fixnum do
  it 'should leave second unmodified' do
    1.second.should == 1
  end
  
  it 'should leave seconds unmodified' do
    1.seconds.should == 1
  end
  
  it 'should convert minute to seconds' do
    1.minute.should == 60
  end

  it 'should convert minutes to seconds' do
    1.minutes.should == 60
  end
end