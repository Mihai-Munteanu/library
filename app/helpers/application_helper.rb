module ApplicationHelper
  # Check if a navigation tab should be active
  # Handles exact matches and nested routes (e.g., /authors/1 matches /authors)
  def nav_tab_class(path)
    # Exact match or path starts with the tab path (for nested routes)
    is_active = request.path == path || request.path.start_with?("#{path}/")

    is_active ? "border-blue-500 text-blue-600" : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
  end

  # Generate sortable column header link
  def sortable_column(column, label, path = request.path)
    direction = if params[:sort] == column.to_s && params[:direction] == "asc"
      "desc"
    else
      "asc"
    end

    current_direction = params[:sort] == column.to_s ? params[:direction] : nil
    is_active = params[:sort] == column.to_s

    link_to url_for(params.permit!.merge(sort: column, direction: direction)),
            class: "flex items-center space-x-1 hover:text-blue-600 #{'text-blue-600' if is_active}" do
      content_tag(:span, label) +
      (is_active ? content_tag(:span, current_direction == "asc" ? "\u2191" : "\u2193", class: "text-blue-600 ml-1") : "")
    end
  end

  # Helper to create a link that opens a modal
  # Usage: modal_link_to "Open Modal", modal_path, "modal"
  def modal_link_to(text, url, frame_id = "modal", **options)
    link_to text, url,
      data: { turbo_frame: frame_id },
      **options
  end

  # Helper to render modal content wrapped in turbo frame
  # Usage: render_modal_frame do ... end
  def render_modal_frame(frame_id = "modal", &block)
    turbo_frame_tag frame_id, &block
  end

  # Build authors index URL with current filters and sorting
  # Excludes pagination and internal parameters
  def authors_index_url_with_filters
    # Use @current_index_url if set by controller, otherwise build from request
    return @current_index_url if @current_index_url.present?

    # Get filter params from request (exclude internal params)
    filter_params = request.query_parameters.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method).to_h

    # Build URL with query parameters
    if filter_params.any?
      base_url = authors_path
      query_string = filter_params.to_query
      "#{base_url}?#{query_string}"
    else
      authors_path
    end
  end
end
