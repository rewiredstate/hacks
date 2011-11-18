class Breadcrumbs
  module Render
    class SoleListItem < Base # :nodoc: all
      def render
        options = {
          :class => "breadcrumbs"
        }.merge(default_options)

        html = ""
        items = breadcrumbs.items
        size = items.size

        items.each_with_index do |item, i|
          html << render_item(item, i, size)
        end

        html
      end

      def render_item(item, i, size)
        text, url, options = *item
        text = wrap_item(url, CGI.escapeHTML(text), options)
        tag(:li, text)
      end
    end
  end
end
