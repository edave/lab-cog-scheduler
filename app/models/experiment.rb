class Experiment < ObfuscatedRecord
    belongs_to :user
    belongs_to :google_calendar
    belongs_to :location
    has_many :slots, :order => :time, :dependent => :destroy
    
    # ACL9 authorization support
    acts_as_authorization_object
    
    acts_as_markdown :desc
    
    validates_presence_of     :name
    validate :presence_of_desc
    validates_presence_of     :user
    validates_presence_of     :location
    validates_numericality_of :time_length, :only_integer => true, :greater_than => 0
    validates_numericality_of :num_subjects, :only_integer => true, :greater_than => 0
    validates_numericality_of :compensation, :only_integer => true, :greater_than => -1
    validates_numericality_of :num_subjects_per_slot, :only_integer => true, :greater_than => 0
  
    # Instance Methods
  
    def presence_of_desc
      errors.add(:desc, "is blank") if desc.to_s.blank?
    end
  
    def open?
      self.read_attribute(:open)
    end
   
    def is_occupied(day)
      occupied = occupied_slots(day)
      return !occupied.empty?
    end
    
    def occupied_slots(day)
      occupied = Array.new
      slots = Slot.find_by_experiment(self.id).find_by_day(day)
      slots.each do |slot|
        occupied << slot if slot.occupied?
      end
      return occupied
  end
  
  def expired?
    self.slots.each do |slot|
      return false unless slot.expired?
    end
    return true
  end
  
  
  # Total number of subjects signed up
  # not including cancelled slots
  def subjects_count
    subject_count = 0
    self.slots.each do |slot|
      subject_count += slot.subjects.count unless slot.cancelled?
    end
    return subject_count
  end

  def filled?
    return subjects_count >= self.num_subjects
  end
  
   def owned_by?(user)
      return user.id == self.user_id
  end
  
  def human_time_length
     return "---" if time_length <= 0 
     hours = time_length.minutes / 1.hours
     minutes = time_length - 60 * hours
     human_arry = []
     if hours > 1
      human_arry << "#{hours} hours"
     elsif hours == 1
      human_arry << "1 hour"
    end
    if minutes > 1
      human_arry << "#{minutes} minutes"
    elsif minutes == 1
      human_arry << "#{minutes} minute"
    end
     return human_arry.join(" and ")
  end
  
  def time_zone
    return "Eastern Time (US & Canada)"
  end
  
  def can_modify?(user)
    return false if user == :false || user == nil
    return (user.id == self.user_id) || user.has_role?(:admin)
  end
  
  # Class Methods
  
  def self.send_reminders
    Experiment.find(:all, {:include => {:slots => :appointments}}) do |experiment|
        day = DateTime.now.in_time_zone(experiment.time_zone).tomorrow
        #log "Experiment: #{experiment.name}"
        if experiment.is_occupied(day)
          ExperimentNotifier.deliver_schedule(experiment, day)
        end
        slots = experiment.occupied_slots(day)
        for slot in slots
          #log "Slot: #{slot.human_datetime}"
          
         slot.appointments.each do |appointment|
          AppointmentNotifier.deliver_reminder(appointment)
         end
        end
    end
  end
end
