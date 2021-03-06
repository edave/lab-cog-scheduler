class Appointment < ActiveRecord::Base
  belongs_to :slot, :counter_cache => true
  belongs_to :subject, :counter_cache => true, :dependent => :destroy
  has_one :experiment, :through => :slot
  
  validates :slot_id, :presence => true
  validates :subject_id, :presence => true
  
  validates_uniqueness_of :subject_id, :scope => :slot_id
  
  validate :limit_appointments

  attr_accessible :slot_id, :subject_id

  def limit_appointments
    return false if slot == nil || slot.experiment == nil
    if slot.appointments.count >= slot.experiment.num_subjects_per_slot
      errors.add("slot", " is filled to capacity")
      return false
    end
    return true
  end
  
  def as_json(options={})
    super(:only => [:id, :subject_id, :slot_id])
  end

end
