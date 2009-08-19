module MoviesHelper
  def created_at_column(record)
    record.created_at
  end
  
  def poster_column(record)
    unless @record.poster.nil?
  	  image_tag(@record.poster.to_s, :size => '135x205')
    end
  end
end