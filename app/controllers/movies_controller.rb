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
    sort = params[:sorting]
    @title_color = NIL
    @release_data_color = NIL
    
    @movies = Movie.all
    
    case sort
    when 'title'
      @movies = Movie.order(:title)
      @title_color = 'Yellow'
    when 'release_date'
      @movies = Movie.order(:release_date)
      @release_data_color = 'Yellow'
    else
      @movies = Movie.all
    end
    
    def not_null parameter
      return (not parameter.empty?)
    end
    
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    @filter_ratings = []
    
    unless params[:ratings].nil?
      @filter_ratings = params[:ratings].keys
      if not_null(params[:ratings].keys)
        #@movies = Movie.all.select{ |movie| @all_ratings.include? params[:ratings].keys }
        #@movies = Movie.none
        @movies = Movie.all.where({rating: @filter_ratings})
      else
        @movies = Movie.all 
      end
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
