module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Helperby Fantasy Cricket"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
