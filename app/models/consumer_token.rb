require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token
  def self.attributes_protected_by_default # default is ["id","type"] '
    ["id"] 
  end
  # Modify this with class_name etc to match your application
  belongs_to :user
  
end