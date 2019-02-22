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
    yellowHilite   = "hilite"
    @movies         = Movie.all
    @all_ratings    = Movie.all_ratings
    
    if session[:title] == yellowHilite  && params[:sorting] == nil 
      params[:sorting] = "title"
    end
    
    if session[:release] == yellowHilite && params[:sorting] == nil
      params[:sorting] = "release_date"
    end
    
    if params[:ratings] == nil && session[:checked] != nil
      params[:ratings] = session[:checked]
      redirect_to movies_path(params)
    end
    
    sort = params[:sorting]
    case sort
    when 'title'
      @movies = Movie.order(:title)
 	    session[:title] = yellowHilite
 	    session[:release] = nil
 	  when 'release_date'
      @movies = Movie.order(:release_date)
      session[:release] = yellowHilite
      session[:title] = nil
    end
    
    unless params[:ratings].nil?
      session[:checked]=params[:ratings]
      if session[:checked] == nil
       session[:checked] = Hash.new()
       @all_ratings.each do (each_rating)
        session[:checked][each_rating]=1
       end
      end
      @movies = @movies.where({rating: session[:checked].keys})
    end
    
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
