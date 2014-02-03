module ApplicationHelper

  def title page_title
    base_title = "Assets Tracker"
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
