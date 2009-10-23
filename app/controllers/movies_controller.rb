class MoviesController < ApplicationController  
  layout 'wartrain'
  
  def index
    if params[:genre].nil?
      @movies = Movie.paginate :page => params[:page],
                               :conditions => ['sort_title like ?', "#{params[:search]}%"],
                               :order => :sort_title, 
                               :per_page => 12
    else
      sql = "select distinct contents.id from contents inner join contents_genres on 
             contents.id = contents_genres.content_id where type = 'Movie' and 
             genre_id = #{params[:genre]} order by contents.sort_title"
      @genre = Genre.find(params[:genre])
      @movies = Movie.paginate_by_sql sql, :page => params[:page], :per_page => 12
    end
  end
  
  def newest
    @movies = Movie.paginate :page => params[:page], :order => 'created_at DESC',
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
  end
  
  def watch 
    debugger
    @movie = Movie.find(params[:id])
    @movie.watched = 1
    @movie.save!
    redirect_to_full_url(@movie.url, 301)
  end
  
end