module ApplicationHelper

  def calculate_pages(total,page_size)
    return 0 if total == nil
    (total.to_f / page_size).ceil
  end
end
