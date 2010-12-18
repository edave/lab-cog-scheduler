# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :consumer_token do |f|
  f.type "GoogleToken"
  f.token "1/ljo0Ddv3eTC9bMhWCfQsz72oRI"
  f.secret "epFm1mu7UDdR5PqM"
  # Add user
end
