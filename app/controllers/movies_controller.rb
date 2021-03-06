class MoviesController < ApplicationController  
  layout 'wartrain'
  
  def index
    if params[:genre].nil?
      @movies = Movie.paginate :page => params[:page],
                               :conditions => ["LOWER(sort_title) like ?", "%#{params[:search]}%"],
                               :order => :sort_title, 
                               :per_page => 12
    else
      sql = "select contents.id, contents.sort_title from contents inner join contents_genres on 
             contents.id = contents_genres.content_id where type = 'Movie' and 
             genre_id = #{params[:genre]} order by contents.sort_title"
      @genre = Genre.find(params[:genre])
      @movies = Movie.paginate_by_sql sql, :page => params[:page], :per_page => 12
    end
  end
  
  def new_additions
    @movies = Movie.paginate :page => params[:page], :order => 'created_at DESC',
                             :per_page => 12
    render :template => 'movies/index'
  end
  
  def new_releases
    @movies = Movie.paginate :page => params[:page], :order => 'release_date DESC',
                             :per_page => 12
    render :template => 'movies/index'
  end
  
  def unwatched
    @movies = Movie.paginate :page => params[:page], 
                             :conditions => 'watched = 0',
                             :order => :sort_title,
                             :per_page => 12
    render :template => 'movies/index'
  end
  
  def genres
    @genres = Genre.find(:all, :order => 'name ASC')
  end

  def show
    @movie = Movie.find(params[:id])
    render :layout => "show_movie"
  end
  
  def watch  
    @movie = Movie.find(params[:id])
    @movie.watched = 1
    @movie.save!
    redirect_to_full_url(@movie.url, 301)
  end
  
end