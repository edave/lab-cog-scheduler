require 'spec_helper'

describe Experiment do
  before(:each) do
     #@experiment = Factory(:experiment)
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
     Experiment.new(:location => Factory(:location)).should have(:no).errors_on(:location) 
   end
  
   it "fails validation with no user (using errors_on)" do
     Experiment.new.should have(1).errors_on(:user)
   end
   
   it "passes validation with a user (using errors_on)" do
     Experiment.new(:user => Factory(:user)).should have(:no).errors_on(:user)
   end
   
   it "fails validation with no description (using errors_on)" do
     Experiment.new.should have(1).errors_on(:desc)
   end
   
   it "passes validation with a description (using errors_on)" do
     Experiment.new(:desc => "My long boring description, blah blah blah").should have(:no).errors_on(:desc)
   end
  
end
