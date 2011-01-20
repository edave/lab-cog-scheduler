require 'spec_helper'

describe Experiment do
  
  before(:each) do
     @user = Factory(:next_user)
     @location = Factory(:next_location)
     @experiment = Factory(:experiment, :user => @user, :location => @location)
   end

   it "fails validation with no name (using errors_on)" do
     Experiment.new.should have(1).errors_on(:name)
   end
   
   it "passes validation with a name (using errors_on)" do
     Experiment.new(:name => "My Testing Name").should have(:no).errors_on(:name)
   end
   
   it "fails validation with no location (using errors_on)" do
     Experiment.new.should have(1).errors_on(:location)
   end
   
   it "passes validation with a location (using errors_on)" do
     Experiment.new(:location => Factory.stub(:location)).should have(:no).errors_on(:location) 
   end
  
   it "fails validation with no user (using errors_on)" do
     Experiment.new.should have(1).errors_on(:user)
   end
   
   it "passes validation with a user (using errors_on)" do
     Experiment.new(:user => Factory.stub(:user)).should have(:no).errors_on(:user)
   end
   
   it "fails validation with no description (using errors_on)" do
     Experiment.new.should have(1).errors_on(:desc)
   end
   
   it "passes validation with a description (using errors_on)" do
     Experiment.new(:desc => "My long boring description, blah blah blah").should have(:no).errors_on(:desc)
   end
   
   it "fails validation with a blank or <= 0 time (using errors_on)" do
     Experiment.new.should have(1).errors_on(:time_length)
     Experiment.new(:time_length => -1).should have(1).errors_on(:time_length)
   end
   
   it "passes validation with a time > 0 (using errors_on)" do
     Experiment.new(:time_length => 15).should have(:no).errors_on(:time_length)  
   end
   
   it "fails validation with a blank or <=0 num of subjects (using errors_on)" do
     Experiment.new.should have(1).errors_on(:num_subjects)
     Experiment.new(:num_subjects => -1).should have(1).errors_on(:num_subjects)
   end
   
   it "passes validation with num subjects > 0 (using errors_on)" do
     Experiment.new(:num_subjects => 15).should have(:no).errors_on(:num_subjects)  
   end
   
   it "fails validation with < 0 compensation (using errors_on)" do
     Experiment.new(:compensation => -1).should have(1).errors_on(:compensation)
   end
   
   it "passes validation with blank compensation (using errors_on)" do
     Experiment.new.should have(:no).errors_on(:compensation)
   end
   
   it "passes validation with compensation >= 0 (using errors_on)" do
     Experiment.new(:compensation => 0).should have(:no).errors_on(:compensation)  
     Experiment.new(:compensation => 20).should have(:no).errors_on(:compensation)
   end

   it "fails validation with a blank or <=0 num of subjects per slot (using errors_on)" do
     Experiment.new(:num_subjects_per_slot => 0).should have(1).errors_on(:num_subjects_per_slot)
     Experiment.new(:num_subjects_per_slot => -1).should have(1).errors_on(:num_subjects_per_slot)
   end
   
   it "fails validation with a fraction num of subjects per slot (using errors_on)" do
    Experiment.new(:num_subjects_per_slot => 3.25).should have(1).errors_on(:num_subjects_per_slot) 
   end
   
   it "passes validation with num subjects > 0 (using errors_on)" do
     Experiment.new.num_subjects_per_slot.should == 1
     Experiment.new(:num_subjects_per_slot => 15).should have(:no).errors_on(:num_subjects_per_slot)  
   end
   
   it "should not be open when new" do
     Experiment.new.open?.should == false
   end
   
   it "should have no subjects when there are no slots" do
     Experiment.new.subjects_count == 0
   end
   
   it "should correctly translate the time length to human friendly format" do
     @experiment.time_length = 15
     @experiment.human_time_length.should == "15 minutes"
     @experiment.time_length = 60
     @experiment.human_time_length.should == "1 hour"
     @experiment.time_length = 61
     @experiment.human_time_length.should == "1 hour and 1 minute"
     @experiment.time_length = 135
     @experiment.human_time_length.should == "2 hours and 15 minutes"
   end
   
   it "should use a valid Ruby time zone" do
     t = Time.now
     lambda {t.in_time_zone(@experiment.time_zone)}.should_not raise_error
   end
   
   # Stub - Test interaction with slots
   
   # Stub - Test filled?

   
end
