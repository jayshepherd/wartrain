class Admin::DelayedJobsController < ApplicationController
  layout 'admin'
  
  active_scaffold :delayed_jobs
end