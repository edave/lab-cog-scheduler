# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.sequence :building do |n|
  "Building ##{n}"
end

Factory.sequence :room do |n|
  "Room ##{n}"
end

Factory.define :location do |f|
  f.building "35"
  f.room "220"
end

Factory.define :next_location do |f|
  f.building { Factory.next :building }
  f.room { Factory.next :room }
end
