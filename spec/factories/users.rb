# Read about factories at http://github.com/thoughtbot/factory_girl
Factory.sequence :email do |n|
  u = "user-email-#{n}@example.com"
  #puts u
  u
end

Factory.sequence :username do |n|
  "username-#{n}"
end

Factory.define :user do |f|
  f.email "harrypotter@example.com"#Factory.next :email
  f.name "Harry Potter"
  f.user_name "harry_username" # Factory.next :username
  f.password "heartGinny"
  f.password_confirmation { |u| u.password }
  f.phone "650-867-5309"
end

Factory.define :next_user, :parent => :user do |f|
  f.email { Factory.next :email }
  f.user_name { Factory.next :username }
end
