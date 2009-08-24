class RenameGenreMoviesToContentGenres < ActiveRecord::Migration
  def self.up
    rename_table :genres_movies, :contents_genres
    rename_column :contents_genres, :movie_id, :content_id
  end

  def self.down
    rename_column :contents_genres, :content_id, :movie_id
    rename_table :contents_genres, :genres_movies
  end
end
