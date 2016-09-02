require './config/environment'
require 'rack/flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  helpers do
    def is_logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end
  end

  get "/" do
    erb :index
  end

end
