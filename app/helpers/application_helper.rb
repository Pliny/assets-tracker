module ApplicationHelper

  def title page_title
    base_title = "Assets Tracker"
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :alert then "alert alert-warning"
    when :error then "alert alert-error"
    end
  end
end
