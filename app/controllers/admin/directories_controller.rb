class Admin::DirectoriesController < ApplicationController
  layout 'admin'
  
  active_scaffold :directory do |config|
    config.list.columns = [:content_type, :physical_path, :nmt_path]
    config.show.columns = [:content_type, :physical_path, :nmt_path, :asset_types,
                           :digest]
    config.create.columns = [:content_type, :physical_path, :nmt_path, :asset_types]
    config.update.columns = [:content_type, :physical_path, :nmt_path, :asset_types, :digest]
    config.action_links.add(:scan, :controller => :directories, :type => :record)
    config.action_links.add(:scan_all, :controller => :directories, :type => :table)
    config.columns[:asset_types].form_ui = :select
    config.columns[:content_type].form_ui = :select
  end
  
  def scan_all
    @directories = Directory.find(:all)
    @directories.each { |directory| directory.send_later(:scan) }
    render :template => 'admin/directories/status', :layout => false
  end
  
  def scan
    @directory = Directory.find(params[:id])
    @directory.send_later :scan
    render :template => 'admin/directories/status', :layout => false
  end
  
end