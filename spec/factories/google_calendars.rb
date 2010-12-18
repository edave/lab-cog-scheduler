# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :google_calendar do |f|
  f.name "Dummy Calnendar"
  f.calendar_id "https://www.google.com/calendar/feeds/default/owncalendars/full/dpitman-test%40gmail.com"
  # Add User
end
