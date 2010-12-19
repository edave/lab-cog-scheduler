require 'spec_helper'

describe User do
  
  before(:each) do
    @user = Factory(:user)
  end
  
  it "passes having a 10-digit phone number" do
    @user.phone.length.should == 10
  end
  
  it "passes validation using a blank phone number (using error_on)" do
    User.new.should have(:no).error_on(:phone)
  end
  
  it "passes validation using a +10 digit phone number (using error_on)" do
    User.new(:phone => "303-867-5309 x42").should have(:no).error_on(:phone)
  end
  
  it "fails validation using invalid email (using error_on)" do
    bad_email_user = Factory.build(:user, :email => "blahooo.com")
    bad_email_user.should have(1).error_on(:email)
  end
  
  it "fails validation using blank email (using error_on)" do
    User.new.should have(1).error_on(:email)
  end
  
  it "fails validation using no name (using error_on)" do
    User.new.should have(1).error_on(:name)
  end
  
  it "passes validation using a name (using error_on)" do
    User.new(:name => "Harry Potter").should have(:no).errors_on(:name)
  end
  
  it "should not have remember_me by default" do
    User.new.remember_me.should == nil
  end

end
