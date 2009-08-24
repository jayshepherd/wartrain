class ContentTypesController < ApplicationController
  layout 'wartrain'
  def index
    @content_types = ContentType.all
    debugger
    if request.env['HTTP_USER_AGENT'].index('Syabas').nil?
      @content_types << 'admin'
    end
  end
end
