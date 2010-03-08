class Admin::ContentTypesController < ApplicationController
  layout 'admin'
  
  active_scaffold :content_type
end