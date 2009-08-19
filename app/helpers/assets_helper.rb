module AssetsHelper
  def directory_column(record)
    record.directory.physical_path
  end
end