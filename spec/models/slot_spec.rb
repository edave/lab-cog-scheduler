require 'spec_helper'

describe Slot do
  it "should not have a time when new" do
    Slot.new.time.should be nil
    
  end
end
