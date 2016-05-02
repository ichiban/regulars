class PagesController < ApplicationController
  before_action :set_page, only: [:show]

  helper_method :page

  def new
    logout 'You need at least 1 facebook page'
  end

  def show
    if current_user.pages.include? @page
      self.current_tab = :dashboard
    else
      head :unauthorized
    end
  end

  private

  def page
    @page
  end

  def set_page
    @page = Page.find(params[:id])
  end
end
