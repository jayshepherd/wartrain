class MmaEvent < Content
  # Associations
  belongs_to :promotion
  
  # Callbacks
  after_create :populate_metadata
  
  def populate_metadata
    begin
      # Populate promotion
      promotion = Promotion.find_by_abbreviation(assets.first.path.split('/').first)
      promotion = Promotion.find_by_name(assets.first.path.split('/').first) unless promotion
      
      # Update poster
      update_poster(nil) if poster == '/art/default.jpg'
      self.save!
    rescue
    end
  end
end