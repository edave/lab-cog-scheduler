source 'http://rubygems.org'

gem 'rails', '3.0.5'

# Bundle edge Rails instead:
gem 'mysql'

# Deploy with Capistrano
gem 'capistrano'

# Add gems for authentication/authorization
gem "devise", '1.1.3'

# For mail_style (css in emails)
gem 'nokogiri', '>=1.4.1'
gem 'css_parser', '>=1.0.0'
gem 'mail_style', '>= 0.1.6'

# For google calendar
gem "edave-portablecontacts"
gem "oauth-plugin", ">=0.4.0.pre1"
gem 'edave-gcal4ruby', ">=0.7.0"

# For In-place-editing
gem 'best_in_place'

# Process Queueing
gem 'delayed_job'

# Routine Job scheduling
gem 'whenever', :require => false

# For encrypting model attributes
gem 'encryptor', '~>1.1.1', :require=> 'encryptor'
gem 'attr_encrypted', '~>1.2', :require=> 'attr_encrypted'
    
# For Markdown text processing
gem 'rdiscount'
gem 'formatize'
gem 'acts_as_markdown'
  
# For Hoptoadapp error monitoring
gem 'hoptoad_notifier', '>=2.2.0'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group:development, :test do
  # Server
  gem 'mongrel'

  # Use Memory Database for testing
  gem 'sqlite3-ruby'
  gem 'memory_test_fix', ">=0.2.0"

  # Add in missing generators
  gem "rails3-generators"
 
  # Add Watchr
  gem "watchr"

  # Testing Framework
  gem "rspec-rails", "~> 2.4"
  #gem 'factory_girl', ">=2.0.0.beta1"
  gem 'factory_girl_rails', ">=1.1.beta1"
  gem 'faker', ">=0.9.4"
  gem 'spork', '~>0.9.0.rc'

  # Time shifting for testing
  gem "timecop"

  # Code Metrics
  gem "metric_fu"

end


