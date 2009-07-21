class MoviesController < ApplicationController  
  def index
    @movies = Movie.paginate :page => params[:page], :order => 'sort_title ASC', 
                             :per_page => 12
  end
  
  def newest
    @movies = Movie.paginate :page => params[:page], :order => 'created_at DESC',
                             :per_page => 12
    render :template => 'movies/index'
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end    
end