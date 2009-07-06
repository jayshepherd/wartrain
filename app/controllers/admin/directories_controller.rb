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
    # Load up the diretory
    directory = Directory.find(params[:id])
    list = ''
    @message = ''
    
    # Check if it's changed since last scan
    Find.find(directory.physical_path) { |path| list = list+path }
    @digest = Digest::MD5.hexdigest(list)
    
    # If it's changed, scan it
    unless @digest == directory.digest
      
      # Delete old assets
      delete_count = 0
      Asset.find(:all).each do |asset|
        unless File.exists?(asset.directory.physical_path+'/'+asset.path)
          Asset.delete(asset.id)
          delete_count = delete_count.next
        end
      end
      
      # Add new assets
      add_count = 0
      Find.find(directory.physical_path) do |path|
        unless File.directory?(path)
          asset_extension = path.split('.').last.downcase
          asset_path = path.gsub(directory.physical_path+'/', '')
          asset_type = directory.asset_types.find_by_extension(asset_extension)
          unless asset_type.blank?
            asset = directory.assets.find_or_initialize_by_path(asset_path)
            if asset.new_record? : add_count = add_count.next end
            asset.save
          end # unless asset_type
        end # unless File.directory
      end # Files.find
      
      # clean up
      directory.update_attribute(:digest, @digest)
      if add_count == 0 then
        @message = 'No new assets were added.'
      elsif add_count == 1 then
        @messsage = 'One new asset was added.'
      else
        @message = add_count.to_s+' new assets were added.'
      end
      if delete_count == 0 then
        @message << ' No assets were delete.'
      elsif delete_count == 1 then
        @message << ' One asset was deleted.'
      else
        @message << ' '+delete_count.to_s+' assets were deleted.'
      end
    else
      @message = "Scan skipped.  The directory hasn't changed."
    end # unless @digest
  end
end