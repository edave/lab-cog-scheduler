class Location < ObfuscatedRecord
  
  ###
  ## Change location factory when revamping this!
  ##
  ###
  
  has_many :experiments
  validates_presence_of :building
  validates_presence_of :room
  validates_uniqueness_of :room, :scope => :building
  
  attr_accessible :building, :room
  
  def as_json(options={})
    super(:only => [:building, :room])
  end
  
  def url
    return "http://whereis.mit.edu/?selection=#{building}&zoom=16"
  end
  
  def human_location
    return "Building #{building}-#{room}"
  end
  
end
