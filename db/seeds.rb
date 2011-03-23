# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Setup site-wide roles
admin = Role.new(:title => "Administrator", :description => "Overall site admin")
admin.slug = "admin"
admin.save!

experimenter = Role.new(:title => "Experimenter", :description => "Base experimenter")
experimenter.slug = "experimenter"
experimenter.save!