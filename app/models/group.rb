class Group < ObfuscatedRecord
  has_many :users
  has_many :experiments, :through => :users
     
  attr_accessible :name, :logo, :logo_file_name, :logo_file_type, :logo_file_size

  # Validations
  validates_presence_of     :name
  
  validates_uniqueness_of   :logo_file_name
  validates_uniqueness_of   :name, :case_sensitive => false
  
  def as_json(options={})
    super(:only => [:name, :logo])
  end
  
  def open_experiments
    open_exps = Array.new
    experiments.each do |exp|
      open_exps << exp if exp.open?
    end
    return open_exps
  end
end
