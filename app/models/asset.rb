class Asset < ActiveRecord::Base
  belongs_to :playable, :polymorphic => true
  belongs_to :directory
  belongs_to :asset_type
  
  #after_create :create_content
  
  private
    def create_content
      if self.directory.content_type == 'Movies'
        #sql = "select movies.id from movies inner join 
        #      assets on movies.id = assets.playable_id where 
        #      assets.playable_type = 'Movie' and 
        #      left(assets.path, instr(assets.path, '/')) = '"+
        @title = self.path.gsub('.'+self.asset_type.extension, '').split('/').last
        @movie = Movie.find_or_create_by_title(:title => @title)
        @movie.assets<<self
      end
    end
    
end