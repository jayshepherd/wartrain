class MmaEventsController < ApplicationController  
  layout 'wartrain'
  
  def index
    @mma_events = MmaEvent.paginate :page => params[:page],
                             :conditions => ['sort_title like ?', "#{params[:search]}%"],
                             :order => 'release_date DESC', 
                             :per_page => 12
  end
  
  def newest
    @mma_events = MmaEvent.paginate :page => params[:page], :order => 'created_at DESC',
                             :per_page => 12
    render :template => 'mma_events/index'
  end
  
  def unwatched
    @mma_events = MmaEvent.paginate :page => params[:page], 
                             :conditions => 'watched = 0',
                             :order => :sort_title,
                             :per_page => 12
    render :template => 'mma_events/index'
  end

  def show
    @mma_event = MmaEvent.find(params[:id])
  end
  
  def watch 
    @mma_event = MmaEvent.find(params[:id])
    @mma_event.watched = 1
    @mma_event.save!
    redirect_to_full_url(@mma_event.url, 301)
  end
  
end