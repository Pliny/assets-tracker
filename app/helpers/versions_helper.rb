module VersionsHelper

  def whodunnit id
    User.find_by_id(id).full_name
  end

  def event val
    case val
    when 'create' then "created"
    when 'update' then "updated"
    when 'delete' then "deleted"
    else val
    end
  end

  def item_type val
    case val
    when 'Asset' then "a cone"
    else val
    end
  end
end
