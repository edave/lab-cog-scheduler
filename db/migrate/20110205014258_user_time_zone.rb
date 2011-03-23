class UserTimeZone < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string
    add_column :experiments, :time_zone, :string
  end

  def self.down
    #remove_column :users, :time_zone
    #remove_column :experiments, :time_zone
  end
end
