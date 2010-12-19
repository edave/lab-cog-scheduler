# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :user do |f|
  f.email "harryp@example.com"
  f.name "Harry Potter"
  f.user_name "HarryPotter42"
  f.password "heartGinny"
  f.password_confirmation { |u| u.password }
  f.phone "650-867-5309"
end
