Factory.sequence :name do |n|
  "My Name #{n}"
end

Factory.define :subject do |subject|
  subject.name "Neville Longbottom"
  subject.email "nlongbottom@example.com"
  subject.phone_number "303-867-5309"
  # Add Apointment?
end

Factory.define :next_subject, :parent => :subject do |f|
  f.name { Factory.next :name }
  f.email { Factory.next :email }
end