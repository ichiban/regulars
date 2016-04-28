module Tabbable
  extend ActiveSupport::Concern

  included do
    helper_method :tab_for
    attr :current_tab, true
  end

  # @param tab [Symbol]
  # @param link [String|URI]
  def tab_for(tab, link, options = nil)
    options = options ? options.dup : {}
    options[:class] = "#{options[:class]} is-active" if current_tab == tab
    view_context.link_to(tab.to_s.titleize, link, options)
  end

  module ClassMethods

  end
end
