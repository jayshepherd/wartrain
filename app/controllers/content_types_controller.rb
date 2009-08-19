class ContentTypesController < ApplicationController
  layout 'movies'
  def index
    @content_types = Array.new
    @content_types << 'movies'
    if request.env['HTTP_USER_AGENT'].index('Syabas').nil?
      @content_types << 'admin'
    end
  end
end
