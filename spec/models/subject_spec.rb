require 'spec_helper'

describe Subject do
  before(:each) do
    @subject = Factory(:subject)
  end
  
  it "should have an encrypted name" do
    @subject.encrypted_name.blank?.should != false
    @subject.name.blank?.should != false
    @subject.name.should_not be @subject.encrypted_name
  end
  
  it "should have an encrypted email" do
    @subject.encrypted_email.blank?.should != false
    @subject.email.blank?.should != false
    @subject.email.should_not be @subject.encrypted_email
  end
  
  it "should have an encrypted phone number" do
    @subject.encrypted_phone_number.blank?.should != false
    @subject.phone_number.blank?.should != false
    @subject.phone_number.should_not be @subject.encrypted_phone_number
  end
  
  it "should have an unformatted phone number" do
    # This is a bit tricky - we rely on the fact that converting the string to an
    # int and then back to a string should only work if the string was a pure number
    # to begin with
    @subject.phone_number.to_i.to_s.should ==  @subject.phone_number
  end
  
  it "passes having a 10-digit phone number" do
    @subject.phone_number.length.should == 10
  end
  
  it "passes validation using a blank phone number (using error_on)" do
    Subject.new.should have(:no).error_on(:phone_number)
  end
  
  it "passes validation using a +10 digit phone number (using error_on)" do
    Subject.new(:phone_number => "303-867-5309 x42").should have(:no).error_on(:phone_number)
  end
  
  it "fails validation using invalid email (using error_on)" do
    bad_email_subject = Factory.build(:subject, :email => "blahfcooo.com")
    bad_email_subject.should have(1).error_on(:email)
  end
  
  it "fails validation using blank email (using error_on)" do
    Subject.new.should have(2).error_on(:email)
  end
  
  it "fails validation using no name (using error_on)" do
    Subject.new.should have(2).error_on(:name)
  end
  
  it "passes validation using a name (using error_on)" do
    Subject.new(:name => "Ginny Weasley").should have(:no).errors_on(:name)
  end
  
end
