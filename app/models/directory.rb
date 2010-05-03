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
    @list = Array.new
    
    # Check if it's changed since last scan
    Find.find(physical_path) { |path| @list.push(path) }
    @new_digest = Digest::MD5.hexdigest(@list.to_s)
    
    # If it's changed, scan it
    unless @new_digest = digest
      self.digest = @new_digest 
      
      # Delete old assets
      assets.each { |asset| asset.destroy unless File.exists?(physical_path+asset.path) }
      
      # Add new assets
      @list.each do |path|
        unless File.directory?(path)
          asset_types.each do |type|
            unless path.index(Regexp.new(type.regex, Regexp::IGNORECASE)).nil?
              asset = assets.find_or_initialize_by_path(path.gsub(physical_path, ''))
              asset.save
            end # unless path
          end # asset_types.each
        end # unless File.directory
      end # @list.each
      self.save
    end
  end
  
end