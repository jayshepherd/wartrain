class Admin::AssetTypesController < ApplicationController
  layout 'admin'
  
  active_scaffold :asset_types do |config|
    config.columns = [:name, :regex]
  end
end