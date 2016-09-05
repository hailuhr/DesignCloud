class CollectionsController < ApplicationController

  get "/collections" do
    if session[:user_id]
      @user = current_user
      @collections = @user.collections
      erb :"collections/collections"
    else
      redirect "/login"
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
    if !is_logged_in?
      @username = "Guest"
    else
      @username = current_user.username
    end
    
    @collections = Collection.random_selection(current_user)
    erb :"collections/discover"
  end

  get "/collections/:id" do
    @collection = Collection.find_by_id(params[:id])
    erb :"collections/show"
  end

  post "/collections" do
    if !params[:name].empty?
      @user = User.find_by_id(session[:user_id])
      @collection = Collection.create(name: params[:name], user_id: @user.id)
      redirect "/collections/#{@collection.id}"
    else
      redirect "/collections/new"
    end
  end

  get "/collections/:id/edit" do
    @collection = Collection.find_by_id(params[:id])
    if @collection.owner?(current_user)
      erb :"collections/edit"
    else
      redirect "/login"
    end
  end

  patch "/collections/:id" do
    @collection = Collection.find_by_id(params[:id])
    if !params[:name].empty?
      @collection.update(name: params[:name])
      params[:links].each do |key, url|
        if !url.empty?
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
    if @collection.owner?(current_user)
      @collection.delete
      redirect "/collections"
    else
      redirect "/login"
    end
  end

  patch "/images/:id" do
    @image = Image.find_by_id(params[:id])
    if !params[:url].empty?
      @image.update(url: params[:url])
      @image.save
      redirect "/collections/#{@image.collection_id}"
    else
      redirect "/collections/image/#{@image.id}"
    end
  end

  delete "/images/:id" do
    @image = Image.find_by_id(params[:id])
    @image.delete
    redirect "/collections/#{@image.collection_id}"
  end

  get "/images/:id/edit" do
    @image = Image.find_by_id(params[:id])
    erb :"collections/image"
  end


  post "/search" do 
    query = params[:search_name]
    @results = Collection.where('lower(name) = ?', query.downcase)
    if @results.empty?
      flash[:message] = "No collections by that name."
    else 
      flash[:message] = " " #without this, flash[:message] stays on page for next search
    end 
    erb :"collections/search"
  end 


end
