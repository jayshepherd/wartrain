class DeleteIdFromGenresMovies < ActiveRecord::Migration
  def self.up
    remove_column :genres_movies, :id
  end

  def self.down
  end
end
