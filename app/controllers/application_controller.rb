require './config/environment'
require 'sinatra/base'
require 'rack-flash'
require 'json'
require 'open-uri'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, "password_security"
    enable :sessions
    use Rack::Flash
   end

  get '/' do 
    erb :index 
  end

  def current_user(session_hash)
    User.find(session_hash[:user_id])
  end

  def logged_in?(session_hash)
    !!session_hash[:user_id]
  end

  def fields_empty?(params)
    error = false
    params.values.each do |input|
      if input.empty?
        flash[:message] = "Please complete all fields." 
        error = true
      end 
    end 
    error
  end 

end 
