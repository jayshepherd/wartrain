class ContentTypesController < ApplicationController
  layout 'wartrain'
  def index
    # @content_types = ContentType.all
    @content_types = Array.new
    @content_types << 'movies'
    @content_types << 'mma_events'
    if request.env['HTTP_USER_AGENT'].index('Syabas').nil?
      @content_types << 'admin'
    end
  end
end
