class Subject < ObfuscatedRecord
  
  attr_encrypted :name, :key => ENCRYPTED_ATTR_PASSKEY
  attr_encrypted :email, :key => ENCRYPTED_ATTR_PASSKEY
  attr_encrypted :phone_number, :key => ENCRYPTED_ATTR_PASSKEY
  
  has_many :appointments, :dependent => :destroy
  has_many :slots, :through => :appointments, :order => :time
  
  before_validation :clean_phone_number
  
  validates :name, :presence => true,
                   :length => {:minimum => 1, :maximum => 254}
  
  validates :email, :presence => true, :email => true
  
  validates_length_of :phone_number, :minimum => 10, :allow_blank => true, :allow_nil => true
  
  def clean_phone_number
    unless self.phone_number.nil?
     self.phone_number = self.phone_number.gsub(/[^\d]/,'')
    end
  end
  
  def as_json(options={})
    super(:only => [:email, :name, :phone_number])
  end
  
end
