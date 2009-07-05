module MoviesHelper
  def assets_column(record)
    join(record.directory.physical_path, record.path)
  end
end