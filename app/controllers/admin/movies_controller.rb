class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    config.list.columns = [:title, :release_date]
  end
end