namespace :labcog do
  namespace :communications do
    desc "Send reminder emails to Participants/Admins"
    task :reminder => :environment do
        Experiment.send_reminders()
    end
  end
end