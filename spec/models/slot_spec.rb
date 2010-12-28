require 'spec_helper'

describe Slot do
  
  
  before(:each) do
     #@slot = Factory.build(:slot)
     #puts "User Email: " + @slot.user.email
   end
  
  it "should not have a time when new" do
    Slot.new.time.should be nil
  end
  
  it "should not be cancelled when new" do
    Slot.new.cancelled.should be false
  end
  
  it "fails validation with no experiment (using errors_on)" do
    Slot.new.should have(1).errors_on(:experiment)
  end
  
  it "fails validation with no time (using errors_on)" do
    Slot.new.should have(1).errors_on(:time)
  end
  
  it "passes validation with experiment" do
    #Slot.new(:experiment => Factory.stub(:experiment)).should have(:no).errors_on(:experiment)
  end
  
  it "passes validation with time" do
    Slot.new(:time => Factory.next(:time)).should have(:no).errors_on(:time)
  end
  
  it "should not be occupied when new" do
    Slot.new.occupied?.should be false
  end
  
  it "should not be filled when new or empty" do
    Slot.new.filled?.should be false
  end
end
