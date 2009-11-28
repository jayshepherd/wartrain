#class Admin::MmaEventsController < ApplicationController
#  layout 'admin'
#  
#  active_scaffold :mma_event do |config|
#    config.label = "MMA Events"
#    config.list.per_page = 20
#    config.list.columns = [:promotion, :title, :sort_title, :release_date, :created_at]
#    config.show.columns = [:promotion, :title, :release_date, :assets, :url, :poster, :watched]
#  end
#  
#  def update_poster
#    @mma_event = MmaEvent.find_by_id(params[:id])
#    @mma_event.update_poster(params[:poster_url])
#    redirect_to :controller =>  'admin/mma_events'
#  end
#end