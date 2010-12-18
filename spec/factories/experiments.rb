# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :experiment do |experiment|
  experiment.name "My Normal Experiment"
  experiment.compensation 15
  experiment.time_length 50
  experiment.slot_close_time 45
  experiment.num_subjects 15
  experiment.num_subjects_per_slot 3
  experiment.desc "# My Title \n Lots of Lorem Ipsum! \n* Let's bulletize \n* Ya, bullets are hot typography"
  # Add Location
  # Add User
  # Add Google Calendar
  # Add Slots?
end
