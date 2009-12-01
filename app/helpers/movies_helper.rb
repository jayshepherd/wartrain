module MoviesHelper
  def created_at_column(record)
    record.created_at
  end
  
  def poster_column(record)
    unless @record.posters[:medium].nil?
  	  image_tag(@record.posters[:medium], :size => '135x205')
    end
  end
end