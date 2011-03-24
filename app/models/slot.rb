class Slot < ObfuscatedRecord
  belongs_to :experiment
  has_many :appointments, :dependent => :destroy
  has_many :subjects, :through => :appointments
   
  validates_presence_of :experiment
  validates_presence_of :time
  
  attr_accessible :time
  attr_readonly :experiment
  
  
  scope :find_by_day, lambda { |d| where(:time  => d.beginning_of_day_in_zone..(d+1.day).beginning_of_day_in_zone).order("time") }
  scope :find_by_occupied, lambda { |e| where(:appointments_count => 1..e.num_subjects_per_slot, :cancelled => false, :experiment_id => e.id).order('time') }
  scope :find_by_available, lambda { |e| where(:appointments_count => 0...e.num_subjects_per_slot,:cancelled => false, :experiment_id => e.id, :time => (Time.zone.now+e.slot_close_time.minutes)..(Time.zone.now + 1.years)).order('time') }
  scope :find_by_full, lambda { |e| where(:appointments_count => e.num_subjects_per_slot, :cancelled => false, :experiment_id => e.id).order('time') }
  scope :find_by_experiment, lambda { |e| where(:experiment_id => e).includes(:experiment)}
  
  # Instance Methods
  
  def open?
    return (!self.expired? and !self.filled?)
  end
  
  def expired?
    return nil if self.time.nil?
    return Time.zone.now+experiment.slot_close_time.minutes > self.time
  end
  
  def occupied?
    return !self.appointments.empty?
  end
  
  def filled?
    return false if self.experiment.nil?
    return self.appointments.count >= self.experiment.num_subjects_per_slot
  end
  
  def empty?
    return self.appointments.empty?
  end
  
  def cancelled?
    return self.cancelled
  end
  
  def cancel
    self.cancelled = true
  end
  
  def parse_datetime(datetimeString, format='%m/%d/%y %I:%M %p')
    begin
      Time.zone = self.time_zone
      datetime =  Time.zone.parse(datetimeString).to_datetime #DateTime.strptime(datetimeString, format)
      #logger.info("DateTime: #{datetime} - #{datetimeString}")
      self.time = datetime
    rescue ArgumentError
      self.time = nil
    end 
  end
  
  def time_zone
    self.experiment.time_zone
  end
  
  def strfdate
   return time_in_time_zone.strftime("%m/%d/%y") unless self.time == nil
   return ""
  end
  
  def time_in_time_zone
    return self.time.in_time_zone(self.time_zone)
  end
  
  
  def hour
     time_in_time_zone.strftime("%I")
  end
  
  def minute
     time_in_time_zone.strftime("%M")
  end 
  
  def meridian
    time_in_time_zone.strftime("%p")
  end
  
  def human_datetime
    return "---" if time.nil? 
    return time_in_time_zone.strftime("%B %e (%a) @ %I:%M %p")
  end
  
  def human_date
    return "---" if time.nil? 
    return time_in_time_zone.strftime("%b %e (%a)")
  end
  
  def human_day_of_week
    return "---" if time.nil? 
    return time_in_time_zone.strftime("%a")
  end
  
  def human_time
    return "---" if time.nil? 
    return time_in_time_zone.strftime("%I:%M %p")
  end
  
  # Class Methods
  
  def self.upcoming(user)
    experiments = Experiment.where(:user_id => user.id).includes(:slots)
    slots = Array.new()
    experiments.each do |experiment|
      slots.concat(experiment.slots_after())
    end
    # Organize slots by time
    # slots.sort_by!{|slot|
    #       
    #     }
    return slots
  end
  
end
