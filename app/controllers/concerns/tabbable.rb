module Tabbable
  extend ActiveSupport::Concern

  included do
    helper_method :tab_for
  end

  # @param tab [Symbol]
  def current_tab=(tab)
    @current_tab = tab
  end

  # @return [Symbol]
  def current_tab
    @current_tab
  end

  # @param tab [Symbol]
  # @param link [String|URI]
  def tab_for(tab, link, options = nil)
    puts "@current_tab = #{@current_tab}"
    puts "tab = #{tab}"
    options = options ? options.dup : {}
    options[:class] = "#{options[:class]} is-active" if @current_tab == tab
    view_context.link_to(tab.to_s.titleize, link, options)
  end

  module ClassMethods

  end
end
