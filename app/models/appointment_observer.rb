class AppointmentObserver < ActiveRecord::Observer
  
  def after_create(appointment)
    slot = appointment.slot
    calendar = slot.experiment.google_calendar
    if calendar != nil
      calendar.delay.add_scheduled_slot(slot.experiment, slot, appointment.subject)
    end
    AppointmentNotifier.delay.confirmation(appointment)
    AppointmentNotifier.delay.notice(appointment)
    
    appointment.scheduled_in_background = true
    appointment.save
  end
  
end
