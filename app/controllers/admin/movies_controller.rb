class Admin::MoviesController < ApplicationController
  layout "admin"
  
  active_scaffold :movie do |config|
    #config.columns[:assets].form_ui = :select 
    #config.list.columns = [:content_type, :physical_path, :nmt_path, :timer]
    #config.show.columns = [:content_type, :physical_path, :nmt_path, :timer]
  end
end