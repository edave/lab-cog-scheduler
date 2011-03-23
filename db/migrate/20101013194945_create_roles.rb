class CreateRoles < ActiveRecord::Migration
  
  # Implements ACL9's version of Roles
  def self.up
    create_table :roles do |t|
      t.string   :title,        :limit => 40
      t.string   :description,  :limit => 255
      t.string   :slug,         :limit => 40
      t.timestamps
    end
    
    create_table "roles_users", :id => false, :force => true do |t|
      t.references  :user
      t.references  :role
      t.timestamps
  end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
