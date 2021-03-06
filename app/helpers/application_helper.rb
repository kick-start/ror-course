module ApplicationHelper
  # not needed
  def asset_exist?(filename)
    !Rails.application.assets.find_asset(filename).nil?
  end
  
  def page_items(collection, page, page_size = 10)
    pages = (collection.size/page_size + 1).to_i
    if page.between?(1, pages)
      start_idx = (page - 1) * page_size
      end_idx = start_idx + page_size
      if page < pages
        collection[start_idx...end_idx]
      else
        collection[start_idx..-1]
      end
    else
      []
    end
  end
  def number_of_pages(collection, page_size = 10)
    (collection.size/10 + 1).to_i
  end
  # not needed end
  def paginated(collection, page_size = 10)
    collection.each_slice(page_size).to_a
  end
  def admin_user?
    user_signed_in? && current_user.is_admin?
  end
  def normal_user?
    user_signed_in? && !current_user.is_admin?
  end
end
