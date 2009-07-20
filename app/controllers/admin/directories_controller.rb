class Admin::DirectoriesController < ApplicationController
  layout "admin"
  
  active_scaffold :directory do |config|
    config.list.columns = [:content_type, :physical_path, :nmt_path, :timer]
    config.show.columns = [:content_type, :physical_path, :nmt_path, :timer,
                           :asset_types, :digest]
    config.update.columns = [:content_type, :physical_path, :nmt_path, 
                             :timer, :asset_types]
    config.action_links.add(:scan, :controller => :directories, :type => :record)
  end
  
  def self.scan_all
    directories = Directory.find(:all)
    directories.each do |directory|
      directory.scan
    end
  end
  
  def scan
    directory = Directory.find(params[:id])
    results = directory.scan
    if results[:scanned] 
      if results[:added] == 0
        @message = 'No new assets were added.'
      elsif results[:added] == 1 
        @messsage = 'One new asset was added.'
      else
        @message = results[:added].to_s+' new assets were added.'
      end
      if results[:deleted] == 0 
        @message << ' No assets were delete.'
      elsif results[:deleted] == 1
        @message << ' One asset was deleted.'
      else
        @message << ' '+results[:deleted].to_s+' assets were deleted.'
      end
    else
      @message = "Scan skipped.  The directory hasn't changed."
    end # unless @digest
    render :layout => false
  end
  
end