class UserController < ApplicationController

  #signup
  #login
  #logout

    get "/signup" do
      if is_logged_in?
        redirect "/collections"
      else
        erb :"/users/signup"
      end
    end


    post "/signup" do
     if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
       @user = User.create(params)
       session[:user_id] = @user.id
       redirect '/collections'
    else
        redirect '/login'
      end
    end


    get '/login' do
      if !is_logged_in?
        erb :"users/login"
      else
        redirect "/collections"
      end
    end


    post '/login' do
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/collections"
      else
        redirect "/login"
      end
    end

    get "/logout" do
      if is_logged_in?
        session.clear
        redirect "/login"
      else
        redirect "/login"
      end
    end

    get "/users/:slug" do
      @user = User.find_by_slug(params[:slug])
      redirect "/collections/show"
    end
    ##################

    

end


#list of collections - home
#link to create new collection - home
#input for name
#input for url


#show page - inside the individual collection
#
