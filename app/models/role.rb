class Role < ActiveRecord::Base
 has_many :users
 attr_accessible :title, :description
 
 validates :slug, :title, :description, :presence => true
 
 def as_json(options={})
   super(:only => [:id, :title])
 end
end
