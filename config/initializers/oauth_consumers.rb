# edit this file to contain credentials for the OAuth services you support.
# each entry needs a corresponding token model.
#
# eg. :twitter => TwitterToken, :hour_feed => HourFeedToken etc.
#
OAUTH_CREDENTIALS={
   :google=>{
     :key=>"www.labcog.com",
     :secret=>"N70Hr9S5LlXO6mc9jbdeA4tX",
     :scope=>"https://www.google.com/calendar/feeds/" # see http://code.google.com/apis/gdata/faq.html#AuthScopes
   }
 }

load 'oauth/models/consumers/service_loader.rb'

# Hack - Remove when gem is upgraded... sigh...
module Oauth
  module Models
    module Consumers
      module Token
        
       
        module InstanceMethods
          
          # Main client for interfacing with remote service. Override this to use
          # preexisting library eg. Twitter gem.
          def client
            @client||=OAuth::AccessToken.new self.class.consumer,token,secret
          end

         
        end
      end
    end
  end
end