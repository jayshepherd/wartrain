class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    config.list.columns = [:title, :release_date, :created_at]
    config.show.columns = [:title, :release_date, :imdb_id, :assets, :url]
    config.action_links.add(:update_metadata, :controller => :movies, 
                            :type => :record)
  end
  
  def update_metadata
    require 'lib/wartrain'
    @movie = Movie.find_by_id(params[:id])
    WarTrain.fetch_metadata(@movie)
    @movie.save
  end
  
  def update_all_metadata
    require 'lib/wartrain'
    @movies = Movie.find(:all)
    @movies.each do |movie|
      WarTrain.fetch_metadata(movie)
      movie.save
    end
  end
end