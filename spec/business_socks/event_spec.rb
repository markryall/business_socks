require File.join(File.dirname(__FILE__), '..', 'spec_helper' )
require 'time'

module BusinessSocks
  describe Event do
    @@midnight = Time.parse('00:00')

    before do
      @event = Event.new('description', 10, 'presenter')
    end
    
    describe 'that has been created' do
      it 'should not be started' do
        @event.should_not be_started
      end
      
      it 'should not be finished' do
        @event.should_not be_finished
      end
      
      it 'should be in stage 0' do
        @event.stage.should == 0
      end
      
      it 'should be in stage 0' do
        @event.stage(10).should == 0
      end
      
      it 'should have 0 elapsed' do
        @event.elapsed.should == 0
      end
      
      it 'should have duration remaining' do
        @event.remaining.should == 10
      end
      
      it 'should have nil finish time' do
        @event.finish_time.should be_nil
      end
    end
    
    describe 'that has been started' do      
      before do
        Time.stub!(:now).and_return(@@midnight)
      end
      
      it 'should determine current time' do
        Time.should_receive(:now).and_return(@@midnight)
        @event.start
      end
      
      it 'should be started' do
        @event.start
        @event.should be_started
      end

      it 'should not be finished when current time is start time' do
        @event.start
        @event.should_not be_finished
      end

      it 'should not be finished when current time is equal to finish time' do
        Time.stub!(:now).and_return(@@midnight, @@midnight+10)
        @event.start
        @event.should_not be_finished
      end
      
      it 'should be finished when current time is greater than finish time' do
        Time.stub!(:now).and_return(@@midnight, @@midnight+11)
        @event.start
        @event.should be_finished
      end
      
      it 'should be at stage 0.25 at quarter way point' do
        Time.stub!(:now).and_return(@@midnight, @@midnight+2.5)
        @event.start
        @event.stage.should == 0.25
      end

      it 'should be at stage 0.5 at halfway point' do
        Time.stub!(:now).and_return(@@midnight, @@midnight+5)
        @event.start
        @event.stage.should == 0.5
      end
      
      it 'should be at stage 0 prior to start' do
        Time.stub!(:now).and_return(@@midnight, @@midnight-5)
        @event.start
        @event.stage.should == 0
      end
      
      it 'should be at stage 1 after end' do
        Time.stub!(:now).and_return(@@midnight, @@midnight+15)
        @event.start
        @event.stage.should == 1
      end
    end
  end
end