class PagesController < ApplicationController
  before_action :set_page, only: [:show]

  helper_method :page

  def new
  end

  def show
    self.current_tab = :dashboard
  end

  private

  def page
    @page
  end

  def set_page
    @page = Page.find(params[:id])
  end
end
