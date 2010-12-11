class CreateOauthConsumerTokens < ActiveRecord::Migration
  def self.up
    
    create_table :consumer_tokens do |t|
      t.integer :user_id
      t.string :type, :limit => 30
      t.string :token, :limit => 1024 # This has to be huge because of Yahoo's excessively large tokens
      t.string :secret
      t.timestamps
    end
    
    # MySQL hack since it only supports a max length of 767 bytes on an index - https://github.com/pelle/oauth-plugin/issues#issue/10
    add_index "consumer_tokens", ["token"], :name => "index_consumer_tokens_on_token", :length => {"token"=>"767"}
    
    # Drop username/pwd from Google Calendars model
    remove_column :google_calendars, :encrypted_login
    remove_column :google_calendars, :encrypted_password
    
  end

  def self.down
    drop_table :consumer_tokens
    
    add_column :google_calendars, :encrypted_login
    add_column :google_calendars, :encrypted_password
  end

end
