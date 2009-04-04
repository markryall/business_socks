require File.join(File.dirname(__FILE__), '..', 'spec_helper' )

module BusinessSocks
  describe Event do
    describe 'that has just been created' do
      it 'should not be started' do
        Event.new.should_not have_started
      end
    end
  end
end