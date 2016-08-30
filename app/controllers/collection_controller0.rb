class CollectionController < ApplicationController

  #new
  #edit
  #delete
  #show
  #collection names to be links

  get "/collections" do
    # if is_logged_in?
    @collections = Collection.all
    if session[:user_id]
      @user = current_user
      erb :"collections/collections"
      #(make collections name into href link in erb)
    else
      erb :"/collections/collections"
    end
  end
  ######## see below for more code for the erb file

  get "/collections/new" do
    if is_logged_in?
      erb :"/collections/new"
    else
      redirect "/login"
    end
  end



  get "/collections/:id" do
    @collection = Collection.find_by_id(params[:id])

    if !is_logged_in? || @collection.user_id != current_user.id
      @collection = Collection.find_by_id(params[:id])
      erb :"/collections/show"
    else
      @collection = Collection.find_by_id(params[:id])
      erb :"/collections/show"
    end

  end




  post "/collections/new" do
    if !params[:name].empty?
      @user = User.find_by_id(session[:user_id])
      @collection = Collection.create(:name => params[:name], :user_id => @user.id)
      redirect "/collections/#{@collection.id}"
    else
      redirect '/collections/new'
    end
  end


  get "/collections/:id/edit" do
    @collection = Collection.find_by_id(params[:id])
    if is_logged_in? && @collection.user_id == current_user.id
      erb :"/collections/edit"
    else
      redirect "/login"
    end
  end


  patch "/collections/:id/edit" do
    @collection = Collection.find_by_id(params[:id])
    if !params[:name].empty?
      #pseudo code for image url
      @collection.update(:name => params[:name])
      @collection.save
      redirect "/collections/#{@collection.id}"
    else
      redirect "/collections/#{@collection.id}/edit"
    end

  end

  get "/collections/:id/delete" do
    @collection = Collection.find_by_id(params[:id])
    if is_logged_in? && @collection.user_id == current_user.id
      @collection.delete
      redirect "/collections"
    else
      redirect "/login"
    end
  end



end


## index home page copyright by 
