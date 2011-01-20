require 'spec_helper'

describe Slot do
  
  before(:each) do
    @slot = Factory(:slot)
    @appointment = Factory(:appointment, :subject => Factory(:next_subject), :slot => @slot)
    @slot.reload
    
    @future_slot = Factory(:slot_in_future)
    @past_slot = Factory(:slot_in_past)
    
    @filled_slot = Factory(:next_slot)
    @filled_slot.experiment.num_subjects_per_slot.times do |i|
      Appointment.new(:slot => @filled_slot, :subject => Factory(:next_subject)).save
    end
    @filled_slot.reload
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
    Slot.new(:experiment => Factory(:experiment)).should have(:no).errors_on(:experiment)
  end
  
  it "passes validation with time" do
    Slot.new(:time => Factory.next(:time)).should have(:no).errors_on(:time)
  end
  
  it "should not be occupied when new" do
    Slot.new.occupied?.should be false
  end
  
  it "should not be expired when in the future" do
    @future_slot.expired?.should == false
  end
  
  it "should be expired when in the past" do
    @past_slot.expired?.should == true
  end
  
  it "should not count any appointments when empty" do
    Slot.new.appointments_count.should == 0
  end
  
  it "should accurately count appointments" do
    @slot.appointments_count.should == 1
    @filled_slot.appointments_count.should ==  @filled_slot.experiment.num_subjects_per_slot
  end
  
  it "should not be filled when new, empty, or partially filled" do
    Slot.new.filled?.should be false
    @future_slot.filled?.should be false
    @slot.filled?.should be false
  end
  
  it "should be filled when full" do
    @filled_slot.filled?.should == true
  end
  
  it "should be open when new or not filled" do 
    Slot.new.open?.should == true
    @slot.open?.should == true
  end
  
  it "should be closed when in the past or filled" do
    @past_slot.open?.should == false
    @filled_slot.open?.should == false
  end

end
