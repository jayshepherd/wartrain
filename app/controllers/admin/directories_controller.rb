class Admin::DirectoriesController < ApplicationController
  layout "admin"
  
  active_scaffold :directory do |config|
    config.label = "Monitored Directories" 
    config.list.columns = [:content_type, :physical_path, :nmt_path, :timer]
    config.show.columns = [:content_type, :physical_path, :nmt_path, :timer,
                           :asset_types, :digest]
    config.update.columns = [:content_type, :physical_path, :nmt_path, 
                             :timer, :asset_types]
    config.action_links.add(:scan, :controller => :directories, :type => :record)
  end
  
  def scan    
    require 'find'
    require 'lib/modules'
    
    # Load up the diretory
    directory = Directory.find(params[:id])
    list = ''
    @message = ''
    
    # Check if it's changed since last scan
    Find.find(directory.physical_path) { |path| list = list+path }
    digest = Digest::MD5.hexdigest(list)
    
    # If it's changed, scan it
    unless digest == directory.digest
      
      # Delete old assets
      Asset.find(:all).each do |asset|
        unless File.exists?(asset.directory.physical_path+asset.path)
          Asset.delete(asset.id)
        end
      end
      
      # Add new assets
      Find.find(directory.physical_path) do |path|
        unless File.directory?(path)
          asset_extension = path.split('.').last.downcase
          asset_path = path.gsub(directory.physical_path+'/', '')
          asset_type = directory.asset_types.find_by_extension(asset_extension)
          unless asset_type.blank?
            asset = directory.assets.find_or_create_by_path(asset_path)
            Modules.create_content(asset)
          end # unless asset_type
        end # unless File.directory
      end # Files.find
      
    end # unless digest
  end
end