module ApplicationHelper
  def nav_tab_class(path)
    request.path == path ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
  end

  # Generate sortable column header link
  def sortable_column(column, label, path = request.path)
    direction = if params[:sort] == column.to_s && params[:direction] == 'asc'
      'desc'
    else
      'asc'
    end

    current_direction = params[:sort] == column.to_s ? params[:direction] : nil
    is_active = params[:sort] == column.to_s

    link_to url_for(params.permit!.merge(sort: column, direction: direction)),
            class: "flex items-center space-x-1 hover:text-blue-600 #{'text-blue-600' if is_active}" do
      content_tag(:span, label) +
      (is_active ? content_tag(:span, current_direction == 'asc' ? '↑' : '↓', class: "text-blue-600 ml-1") : '')
    end
  end
end
