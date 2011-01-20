require 'spec_helper'

describe Appointment do
  
  before(:each) do
     @subject = Factory(:next_subject)
     @user = Factory(:next_user)
     @location = Factory(:next_location)
     @experiment = Factory(:experiment, :user => @user, :location => @location)
     @slot = Factory(:slot, :experiment => @experiment)
     @appointment = Factory(:appointment, :slot => @slot, :subject => @subject)
     
     @filled_slot = Factory(:next_slot)
     @filled_slot.experiment.num_subjects_per_slot.times do |i|
       Appointment.new(:slot => @filled_slot, :subject => Factory(:next_subject)).save
     end
     @filled_slot.reload
  end

  it "fails validation with no subject (using errors_on)" do
     Appointment.new.should have(1).errors_on(:subject_id)
  end
   
  it "fails validation with no slot (using errors_on)" do
     Appointment.new.should have(1).errors_on(:slot_id)
  end
   
  it "passes vaidation with a subject" do
    Appointment.new(:subject => @subject).should have(:no).errors_on(:subject_id)
  end
  
  it "passes validation with a slot" do
    Appointment.new(:slot => @slot).should have(:no).errors_on(:slot_id)
  end
  
  it "can access the experiment" do
    @appointment.experiment.should_not be nil
  end
  
  it "fails validation with existing subject/slot pair (using errors_on)" do
    Appointment.new(:slot => @appointment.slot, :subject => @appointment.subject).should have(1).errors_on(:subject_id)
  end
  
  it "passes validation with different subject/slot pair (using errors_on)" do
    Appointment.new(:slot => @appointment.slot, :subject => Factory(:next_subject)).should have(:no).errors_on(:subject_id)
  end
  
  it "can not be added to a filled slot" do
    Appointment.new(:slot => @filled_slot, :subject => Factory(:next_subject)).should have(1).errors_on(:slot)
  end
  
  it "can be added to a partially filled slot" do
    Appointment.new(:slot => @slot, :subject => Factory(:next_subject)).should have(:no).errors_on(:slot)
  end
  
end
