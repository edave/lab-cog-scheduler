source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
gem 'mysql'

# Deploy with Capistrano
gem 'capistrano'

# Add gems for authentication/authorization
gem "devise", '1.1.3'
gem "acl9"

# For mail_style (css in emails)
gem 'nokogiri', '>=1.4.1'
gem 'css_parser', '>=1.0.0'
gem 'mail_style', '>= 0.1.6'

# For google calendar
gem "edave-portablecontacts"
gem "oauth-plugin", ">=0.4.0.pre1"
gem 'edave-gcal4ruby'


# For Rooster
gem 'daemons', '1.1.0'
gem 'eventmachine', '>=0.12.10'
gem 'chronic', '>=0.2.3', :require=> 'chronic'

# For encrypting model attributes
gem 'encryptor', '~>1.1.1', :require=> 'encryptor'
gem 'attr_encrypted', '>=1.1.2', :require=> 'attr_encrypted'
  
# For background tasks
gem 'rufus-scheduler', :require=> "rufus/scheduler"
  
# For Markdown text processing
gem 'rdiscount'
gem 'formatize'
gem 'acts_as_markdown'
  
# For Hoptoadapp error monitoring
gem 'hoptoad_notifier', '>=2.2.0'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # Server
  gem 'mongrel'

  # Continuous Tester
  gem "ZenTest"

  # Add-ons for AutoTest
  gem "autotest-growl" # OS X Growl Integration
  gem "autotest-fsevent" # Use OS X's File System API
  gem "redgreen" # Color Output
  

  # Testing Framework
  gem "rspec-rails", "~> 2.3.1"
  gem 'factory_girl_rails'

end


