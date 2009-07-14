class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    config.list.per_page = 20
    config.list.columns = [:title, :release_date, :created_at]
    config.show.columns = [:title, :release_date, :imdb_id, :assets, :url, :poster]
    config.action_links.add(:update_metadata, :controller => :movies, 
                            :type => :record)
    config.action_links.add(:update_all_metadata, :controller => :movies, 
                            :type => :table)
  end
  
  def update_metadata
    require 'lib/wartrain'
    @movie = Movie.find_by_id(params[:id])
    WarTrain.fetch_metadata(@movie)
    @movie.save
    render (:template => 'admin/movies/status', :layout => false) 
  end
  
  def update_all_metadata
    require 'lib/wartrain'
    @movies = Movie.find(:all)
    @movies.each do |movie|
      begin
        WarTrain.fetch_metadata(movie)
        movie.save
      rescue
        nil
      end
    end
  end
  
  def update_poster
    require 'lib/wartrain'
    @movie = Movie.find_by_id(params[:id])
    @poster_url = params[:poster_url]
    path = Rails.root.join('public/art/movies',@movie.id.to_s+'.jpg')
    WarTrain.update_poster(@poster_url, path)
    redirect_to :controller =>  'admin/movies'
  end
end