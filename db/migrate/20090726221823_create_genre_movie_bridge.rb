class CreateGenreMovieBridge < ActiveRecord::Migration
  def self.up
    create_table :genres_movies, :force => true do |t|
      t.integer :genre_id
      t.integer :movie_id
      t.timestamps
    end
  end

  def self.down
    drop_table :genres_movies
  end
end