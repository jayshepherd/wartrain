class Admin::AssetsController < ApplicationController
  layout 'admin'
  
  active_scaffold :asset do |config|
    config.columns[:directory].form_ui = :select
    config.columns = [:directory, :path]
    config.subform.columns.exclude :directory
  end
end