# Load content types
content_types = (
  'Movies'
)

content_types.each do |name|
  ContentType.find_or_create_by_name(name).save!
end

# Load asset types
asset_types = {
  'Audio Video Interleave'=>'\.avi$',
  'Disk Image'=>'\.img$',
  'ISO 9660 Disk Image'=>'\.iso$',
  'Mastroka'=>'\.mkv$',
  'MPEG Transport Stream'=>'\.ts$',
  'MPEG Transport Stream Container Extension'=>'\.m2ts$',
  'VIDEO_TS Folder'=>'\/VIDEO_TS\/'
}

asset_types.each do |key,value|
  AssetType.find_or_create_by_name_and_regex(key,value).save!
end


