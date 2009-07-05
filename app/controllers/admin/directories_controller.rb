class Admin::DirectoriesController < ApplicationController
  layout "admin"
  
  active_scaffold :directory do |config|
    config.label = "Monitored Directories" 
    config.list.columns = [:content_type, :physical_path, :nmt_path, :timer]
    config.show.columns = [:content_type, :physical_path, :nmt_path, :timer]
    config.action_links.add (:scan, :controller => :directories, :type => :record)
  end
  
  def scan
  require 'find'
    directory = Directory.find(params[:id])
    @count = 0
    Find.find(directory.physical_path) do |path|
      unless File.directory?(path)
        asset_path = path.gsub(directory.physical_path+'/', '')
        asset = directory.assets.find_or_create_by_path(asset_path)
        if asset.new_record?
          # Populate Metadata
          @count.next
        end
      end
    end
  end
  
end