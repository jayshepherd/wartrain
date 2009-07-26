class MoviesController < ApplicationController  
  def index
    @movies = Movie.paginate :page => params[:page], :order => :sort_title, 
                             :per_page => 12
  end
  
  def newest
    @movies = Movie.paginate :page => params[:page], :order => 'created_at DESC',
                             :per_page => 12
    render :template => 'movies/index'
  end

  def show
    @movie = Movie.find(params[:id])
  end
end