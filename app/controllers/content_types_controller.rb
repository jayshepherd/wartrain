class ContentTypesController < ApplicationController
  layout 'wartrain'
  def index
    @content_types = ContentType.find(:all)
  end
end
