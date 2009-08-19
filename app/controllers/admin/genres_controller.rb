class Admin::GenresController < ApplicationController
  layout 'admin'
  
  active_scaffold :genre 
end