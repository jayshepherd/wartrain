namespace :wartrain do
  task(:makedirs) do
    Dir.mkdir("#{RAILS_ROOT}/public/art/backgrounds")
    Dir.mkdir("#{RAILS_ROOT}/public/playlists")
  end
end