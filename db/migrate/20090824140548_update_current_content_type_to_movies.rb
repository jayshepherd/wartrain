class UpdateCurrentContentTypeToMovies < ActiveRecord::Migration
  def self.up
    Content.update_all("type = 'Movie'", "type IS NULL")
  end

  def self.down
    Content.update_all("type = null", "type = 'Movie'")
  end
end
