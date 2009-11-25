types = {
  'Audio Video Interleave'=>'\.avi$',
  'Disk Image'=>'\.img$',
  'ISO 9660 Disk Image'=>'\.iso$',
  'Mastroka'=>'\.mkv$',
  'MPEG Transport Stream'=>'\.ts$',
  'MPEG Transport Stream Container Extension'=>'\.m2ts$',
  'VIDEO_TS Folder'=>'\/VIDEO_TS\/'
}

types.each do |key,value|
  AssetType.find_or_create_by_name_and_regex(key,value).save!
end
