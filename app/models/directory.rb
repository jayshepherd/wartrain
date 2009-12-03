class Directory < ActiveRecord::Base
  
  # Associations
  belongs_to :content_type
  has_many :assets
  has_and_belongs_to_many :asset_types
  
  validates_format_of :physical_path, :with => /[\/]$/i
  validates_format_of :nmt_path, :with => /[\/]$/i
  
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
    if @new_digest == digest
      @results[:scanned] = false
    else
      self.digest = @new_digest
      @results[:scanned] = true
      
      # Delete old assets
      assets.each do |asset|
        unless File.exists?(physical_path+asset.path)
          asset.delete
          @results[:deleted] = @results[:deleted].next                         
        end
      end
      
      # Add new assets
      @list.each do |path|
        unless File.directory?(path)
          asset_types.each do |type|
            unless path.index(Regexp.new(type.regex, Regexp::IGNORECASE)).nil?
              asset = assets.find_or_initialize_by_path(path.gsub(physical_path, ''))
              if asset.new_record? : @results[:added] = @results[:added].next end
              asset.save
            end # unless path
          end # asset_types.each
        end # unless File.directory
      end # @list.each
      self.save
    end
    return @results
  end
  
  def self.scan_all
    @directories = Directory.find(all)
    @directories.each { |dir| dir.scan }
  end
end