class MoviesController < ApplicationController  
  def index
    if params[:genre].nil?
      @movies = Movie.paginate :page => params[:page], :order => :sort_title, 
                               :per_page => 12
    else
      sql = "select distinct movies.id from movies inner join genres_movies on 
             movies.id = genres_movies.movie_id where genre_id = #{params[:genre]} 
             order by movies.sort_title"
      @genre = Genre.find(params[:genre])
      @movies = Movie.paginate_by_sql sql, :page => params[:page], :per_page => 12
    end
  end
  
  def newest
    @movies = Movie.paginate :page => params[:page], :order => 'created_at DESC',
                             :per_page => 12
    render :template => 'movies/index'
  end
  
  def genres
    @genres = Genre.find(:all)
  end

  def show
    @movie = Movie.find(params[:id])
  end
end