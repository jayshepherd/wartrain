class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    config.list.per_page = 20
    config.list.columns = [:title, :sort_title, :release_date, :created_at]
    config.show.columns = [:title, :release_date, :imdb_id, :assets, :url, :poster]
    config.action_links.add(:update_metadata, :controller => :movies, 
                            :type => :record)
    config.action_links.add(:update_all_metadata, :controller => :movies, 
                            :type => :table)
  end
  
  def update_metadata
    @movie = Movie.find_by_id(params[:id])
    @movie.populate_metadata
    @movie.save!
    render (:template => 'admin/movies/status', :layout => false) 
  end
  
  def update_all_metadata
    @movies = Movie.find(:all)
    @movies.each do |movie|
      begin
        movie.populate_metada
        movie.save
      rescue
        nil
      end
    end
  end
  
  def update_poster
    require 'lib/wartrain'
    @movie = Movie.find_by_id(params[:id])
    @movie.update_poster(params[:poster_url])
    redirect_to :controller =>  'admin/movies'
  end
end