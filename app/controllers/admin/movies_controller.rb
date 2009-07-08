class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    config.list.columns = [:title, :release_date]
    config.show.columns = [:title, :release_date, :imdb_id, :assets]
  end
  
  def fetch_metadata
    #
  end
end