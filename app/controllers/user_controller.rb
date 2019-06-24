
class UserController < ApplicationController

    get '/signup' do 
      redirect '/reviews' if logged_in?(session)
      erb :"users/new"
 
  end 
  
  post "/signup" do
    #validate username and email uniqueness
    if User.invalid?(params)
      flash[:message] = "Sorry, that username or email is already taken."
      redirect to '/signup'
    end 
   
    # params cannot be empty
    redirect to '/signup' if fields_empty?(params)
  
    @user = User.create(:username => params[:username], 
           :email => params[:email],
           :password => params[:password])	 
  
    #assign session user_id to new user
    session[:user_id] = @user.id 
    redirect '/reviews'
  end

  get '/logout' do 
    session.clear
    redirect '/'
  end 

  get "/login" do
    redirect '/reviews' if logged_in?(session)
    erb :"users/login"
  end

  post "/login" do
    # params cannot be empty
    redirect to '/login' if fields_empty?(params)

    # authenticate username and password
    @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/reviews"
      else
        flash[:message] = "Incorrect username or password. Please log in again."
        redirect '/login'
      end
  end

  get "/users/:slug" do
    if !logged_in?(session)
        flash[:message] = "You must be logged in to view your profile."
        redirect '/'
    else
        # find user by slugified username
        @user = User.find_by_slug(params[:slug])

        # only the current user can view their own users/:slug page
        if @user && @user.id == current_user(session).id
          erb :"/users/show"
        else
          flash[:message] = "Sorry, you cannot view another user's profile."
          redirect '/login'
      end
    end
  end

  get "/users/:slug/edit" do
    if logged_in?(session)
      @user = User.find_by_slug(params[:slug])
      if @user.id == current_user(session).id
        erb :"/users/edit"
      else
        redirect '/reviews'
      end
    else
      flash[:message] = "You must be logged in to edit your profile."
      redirect '/reviews'
    end
   end


   patch "/users/:slug" do
    redirect '/login' if !logged_in?(session)

    @user = User.find_by_slug(params[:slug])

    if params[:username].empty? || params[:email].empty?
      flash[:message] = "You must provide a username and email address."
      redirect "/users/#{@user.slug}/edit" 
    end 

    # Require current password to be entered
    if !@user.authenticate(params[:password]) || params[:password].empty?
      flash[:message] = "You must enter your current password."
      redirect "/users/#{@user.slug}/edit" 
    end 

      @user.username = params[:username]
      @user.email = params[:email]

      #Check if the optional new password field is not emtpy
      if !params[:new_password].empty? 
          # Need to confirm new password
        if params[:new_password_confirmation].empty? 
          flash[:message] = "New password confimration must be filled"
          redirect "/users/#{@user.slug}/edit" 
        end 
        
        # Must have matching new password and new password confirmation
        if  params[:new_password] != params[:new_password_confirmation]
          flash[:message] = "New password and password confirmation do not match."
          redirect "/users/#{@user.slug}/edit" 
        end 
  
        # Update new password
        @user.password = params[:new_password]
        @user.password_confirmation = params[:new_password_confirmation]
      end
       
      @user.save
      flash[:message] = "Your info has been updated."
      redirect "/users/#{@user.slug}"
    end


end 