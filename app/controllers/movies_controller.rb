class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # byebug
    @all_ratings = Movie.all_ratings

    new_params = {}
    need_redirect = false
    if params[:ratings].nil? && !session[:ratings].nil?
      new_params[:ratings] = session[:ratings]
      need_redirect = true
    end
    if params[:sort_by].nil? && !session[:sort_by].nil?
      new_params[:sort_by] = session[:sort_by]
      need_redirect = true
    end
    
    # Set sessions
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
      new_params[:ratings] = params[:ratings]
    end
    if !params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
      new_params[:sort_by] = params[:sort_by]
    end
    
    if need_redirect
      redirect_to movies_path(new_params)
    end

    @movies = params[:ratings].nil? ? Movie.all : Movie.where(rating: params[:ratings].keys)
    @checked = params[:ratings].nil? ? @all_ratings : params[:ratings].keys
    @movies = @movies.order(params[:sort_by])
    @sort_by = params[:sort_by]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
