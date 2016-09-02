class UsersController < ApplicationController

  get "/signup" do
    if is_logged_in?
      redirect "/collections"
    else
      erb :"users/signup"
    end
  end


  post "/signup" do
   if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
     @user = User.create(params)
     session[:user_id] = @user.id
     redirect "/collections/discover"
    else
      "Fill in all information"
      redirect '/signup'
    end
  end


  get '/login' do
    if !is_logged_in?
      erb :"users/login"
    else
      redirect "/collections/discover"
    end
  end


  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/collections/discover"
    else
      redirect "/login"
    end
  end

  get "/logout" do
    if is_logged_in?
      session.clear
      redirect "/"
    else
      redirect "/login"
    end
  end

end

