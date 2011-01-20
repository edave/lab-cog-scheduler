# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.sequence :time do |n|
  time = Time.now
  # Reset to hh:00:00
  time = time - time.min.minutes - time.sec
  day = n % 6 # Six slots per day
  minute = n * 45 # A slot every 45 min
  Time.now - 2.days + day.days + minute.minutes
end


Factory.define :slot do |f|
  f.experiment { |a| a.association(:experiment) }
  f.time { Factory.next(:time) }
  f.cancelled false
end

Factory.define :next_slot, :parent => :slot do |f|
  f.time { Factory.next(:time) }
end

Factory.define :slot_in_future, :parent => :slot do |f|
  f.time Time.now + 2.day - 1.hour - 15.minutes
end

Factory.define :slot_in_past, :parent => :slot do |f|
  f.time Time.now - 1.day + 1.hour + 15.minutes
end

Factory.define :partially_filled_slot, :parent => :slot do |f|
  f.time { Factory.next(:time) }
end

Factory.define :filled_slot, :parent => :slot do |f|
  f.time { Factory.next(:time) }
end
