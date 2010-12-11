require 'oauth/controllers/consumer_controller'
class OauthConsumersController < ApplicationController
  include Oauth::Controllers::ConsumerController
  
  before_filter :authenticate_user!, :only=>:index
  
  def index
    @consumer_tokens=ConsumerToken.all :conditions=>{:user_id=>current_user.id}
    @services=OAUTH_CREDENTIALS.keys-@consumer_tokens.collect{|c| c.class.service_name}
  end
  
  
  # HACK - 12/10/10 - DPitman
  # For some reason, OAuth plugin's controller method doesn't get recognized...
  def callback
          logger.info "CALLBACK"
          @request_token_secret=session[params[:oauth_token]]
          if @request_token_secret
            logger.info("#{@consumer}")
            @token=@consumer.find_or_create_from_request_token(current_user,params[:oauth_token],@request_token_secret,params[:oauth_verifier])
            session[params[:oauth_token]] = nil
            if @token
              # Log user in
              if logged_in?
                flash[:notice] = "#{params[:id].humanize} was successfully connected to your account"
              else
                self.current_user = @token.user 
                flash[:notice] = "You logged in with #{params[:id].humanize}"
              end
              go_back
            else
              flash[:error] = "An error happened, please try connecting again"
              redirect_to oauth_consumer_url(params[:id])
            end
          end

        end
        def self.included(controller)
                controller.class_eval do  
                  before_filter :load_consumer, :except=>:index
                  skip_before_filter :verify_authenticity_token,:only=>:callback
                end
              end

              def index
                @consumer_tokens=ConsumerToken.all :conditions=>{:user_id=>current_user.id}
                # The services the user hasn't already connected to
                @services=OAUTH_CREDENTIALS.keys-@consumer_tokens.collect{|c| c.class.service_name}
              end      

              # creates request token and redirects on to oauth provider's auth page
              # If user is already connected it displays a page with an option to disconnect and redo
              def show
                unless @token
                  @request_token=@consumer.get_request_token(callback_oauth_consumer_url(params[:id]))
                  session[@request_token.token]=@request_token.secret
                  if @request_token.callback_confirmed?
                    redirect_to @request_token.authorize_url
                  else
                    redirect_to(@request_token.authorize_url + "&oauth_callback=#{callback_oauth_consumer_url(params[:id])}")
                  end
                end
              end

              def destroy
                throw RecordNotFound unless @token
                @token.destroy
                if params[:commit]=="Reconnect"
                  redirect_to oauth_consumer_url(params[:id])
                else
                  flash[:notice] = "#{params[:id].humanize} was successfully disconnected from your account"

                  go_back
                end
              end

              protected

              # Override this in your controller to decide where you want to redirect user to after callback is finished.
              def go_back
                redirect_to root_url
              end

              def load_consumer
                consumer_key=params[:id].to_sym
                logger.info("Consumer Key: #{consumer_key.to_s}")
                
                throw RecordNotFound unless OAUTH_CREDENTIALS.include?(consumer_key)
                deny_access! unless logged_in? || OAUTH_CREDENTIALS[consumer_key][:allow_login]
                @consumer="#{consumer_key.to_s.camelcase}Token".constantize
                @token=@consumer.find(:first, :conditions=>{:user_id=>current_user.id.to_s}) if logged_in?
              end

              # Override this in you controller to deny user or redirect to login screen.
              def deny_access!
                head 401
              end
  
  # Change this to decide where you want to redirect user to after callback is finished.
  # params[:id] holds the service name so you could use this to redirect to various parts
  # of your application depending on what service you're connecting to.
  def go_back
    redirect_to root_url
  end
  
  # The plugin requires logged_in? to return true or false if the user is logged in. Uncomment and
  # call your auth frameworks equivalent below if different. eg. for devise:
  #
  def logged_in?
     user_signed_in?
  end
    
  # The plugin requires current_user to return the current logged in user. Uncomment and
  # call your auth frameworks equivalent below if different.
  # def current_user
  #   current_person
  # end

  # The plugin requires a way to log a user in. Call your auth frameworks equivalent below 
  # if different. eg. for devise:
  #
  def current_user=(user)
     sign_in(user)
  end
  
  # Override this to deny the user or redirect to a login screen depending on your framework and app
  # if different. eg. for devise:
  #
  def deny_access!
     raise Acl9::AccessDenied
  end

  
end
