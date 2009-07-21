class Directory < ActiveRecord::Base
  
  # Associations
  has_many :assets
  has_and_belongs_to_many :asset_types
  
  # Virtual Attributes
  def to_label # for ActiveScaffold
    physical_path
  end

  # Public instance methods
  def scan
    require 'find'
    
    # Load up the diretory
    @results = {:scanned => false, :deleted => 0, :added => 0}
    @list = Array.new
    
    # Check if it's changed since last scan
    Find.find(physical_path) { |path| @list.push(path) }
    @new_digest = Digest::MD5.hexdigest(@list.to_s)
       
    
    # If it's changed, scan it
    unless @new_digest == digest
      digest = @new_digest
      @results[:scanned] = true
      
      # Delete old assets
      assets.each do |asset|
        unless File.exists?(physical_path+'/'+asset.path)
          asset.delete
          @results[:deleted] = @results[:deleted].next
        end
      end
      
      # Add new assets
      @list.each do |path|
        unless File.directory?(path)
          asset_extension = path.split('.').last.downcase
          asset_path = path.gsub(physical_path, '')
          asset_type = asset_types.find_by_extension(asset_extension)
          unless asset_type.blank?
            asset = assets.find_or_initialize_by_path(asset_path)
            if asset.new_record? : @results[:added] = @results[:added].next end
            asset.save
          end # unless asset_type
        end # unless File.directory
      end # @list.each
    end
    return @results
  end
  
end