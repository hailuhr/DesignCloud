class CollectionsController < ApplicationController

  get "/collections" do
    if session[:user_id]
      @user = current_user
      @collections = @user.collections
      erb :"collections/collections"
    else
      erb :"collections/collections"
    end
  end

  get "/collections/new" do
    if is_logged_in?
      erb :"collections/new"
    else
      redirect "/login"
    end
  end

  get "/collections/discover" do 
    @collections = []
    @all_without_user = []
    Collection.all.each do |collection|
      if collection.user_id != current_user.id
        @all_without_user << collection 
      end 
    end 

    10.times do 
      @instance = @all_without_user.sample 
      @collections << @instance
      @all_without_user.delete(@instance)
    end 

    erb :"collections/discover"
  end

  get "/collections/:id" do
    @collection = Collection.find_by_id(params[:id])
    if !is_logged_in? || @collection.user_id != current_user.id
      @collection = Collection.find_by_id(params[:id])
      erb :"collections/show"
    else
      @collection = Collection.find_by_id(params[:id])
      erb :"collections/show"
    end
  end

  post "/collections/new" do
    if !params[:name].empty?
      @user = User.find_by_id(session[:user_id])
      @collection = Collection.create(name: params[:name], user_id: @user.id)
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
      @collection.update(name: params[:name])
      params[:links].each do |k, url|
        if url != "" 
          @image = Image.new(url: url)
          @collection.images << @image
          @collection.save
        end 
      end
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

  get "/collections/image/:id" do  
    @image = Image.find_by_id(params[:id])
    erb :"collections/image"
  end

  patch "/collections/image/:id" do 
    @image = Image.find_by_id(params[:id])
    if params[:url] != ""
      @image.update(url: params[:url])
      @image.save
      redirect "/collections/#{@image.collection_id}"
    else
      redirect "/collections/image/#{@image.id}"
    end
  end

  get "/collections/delete_image/:id" do
    @image = Image.find_by_id(params[:id])
    @image.delete 
    redirect "/collections/#{@image.collection_id}"
  end




end


