module UserHelper
  
  def nav_link_to(link_name, link_path, icon)
    class_name = current_page?(link_path) ? 'active' : ''
    content_tag(:li, :class => class_name) do
      link_to link_path do
        capture_haml do
          haml_tag "span.glyphicon.glyphicon-#{icon}"
          haml_concat "#{link_name}"
        end
      end
    end
  end
end