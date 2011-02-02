require 'gcal4ruby'
class GoogleCalendar < ObfuscatedRecord
  
  has_many :experiments
  
  belongs_to :user
  
  has_one :google_token, :through => :user
  
  attr_accessible :name
   
  validates_presence_of :name
  
  validate :confirm_calendar
  
  def self.calendars(accesstoken)
    service = self.get_service(accesstoken)
    unless service == nil
        return service.calendars({:fields => ['id','title']})
    end
  end
  
  def find_calendar_id
    service = get_service()
    if service
    new_calendar = GCal4Ruby::Calendar.find(service, name, {'max-results' => '10'})
    if new_calendar == nil or new_calendar.empty?
      errors.add(:name, "Calendar could not be found")
      return false
    end
    new_calendar = new_calendar.first
    self.calendar_id = new_calendar.id
    self.name = new_calendar.title
    end
  end
  
  def calendar_html
    my_calendar = self.calendar
    html = "Error: calendar not found"
    unless my_calendar == nil
      html = my_calendar.to_iframe({:showCalendars => '0', :showTz => '0', :showTitle => '0'})
      #logger.info("Cal: #{html}")
    end
    return html
  end
  
  def confirm_calendar
    service = get_service()
    if service != nil and !name.blank?
      new_calendar = GCal4Ruby::Calendar.find(service, name, {:scope => :first})
      unless new_calendar == nil || new_calendar.empty?
        return true
      end
    end
    errors.add(:name, " could not find the calendarg")
      
    return false
  end
  
  def calendar
    service = get_service()
    begin
    if service != nil
      my_calendar = GCal4Ruby::Calendar.find(service, {:id=>self.calendar_id})
      return nil if my_calendar.class == Array.class and my_calendar.empty?
      
      return my_calendar
    end
    rescue GData4Ruby::HTTPRequestFailed
      return nil
    end
  end
  
  def add_scheduled_slot(experiment, slot, subject)
    start_time = slot.time
    endtime = start_time + experiment.time_length.minutes
    event = GCal4Ruby::Event.new(get_service, {:calendar => self.calendar})
    event.title = experiment.name + ' - ' + subject.name
    event.content = "An experiment for " + experiment.name \
                  + " was automatically scheduled for this time by the Lab Cog Scheduler\n"  \
                  + "Subject: " + subject.name \
                  + "\n\nExperiment Contact " + experiment.user.name + ", " + experiment.user.email \
                  + "Lab Cog - Escape the Experiment Grind - http://www.labcog.com"
    event.where = experiment.location.human_location
    event.start_time = start_time
    event.end_time = endtime
    event.save
  end 
  
  def get_service()
    GoogleCalendar.get_service(self.google_token.client)
  end
  
  def self.get_service(accesstoken)
    service = GCal4Ruby::Service.new({:use_ssl => true, :check_public => false, :debug => false, :GData4RubyService => :OAuthService})
    service.authenticate({:access_token=>accesstoken}) 
    return service
  end
end
