class PagesController < ApplicationController
  def show
    raise ActiveRecord::RecordNotFound unless params['page'].match(/^[a-z]+$/)
    render :template => "pages/#{params['page']}"
  end
end
