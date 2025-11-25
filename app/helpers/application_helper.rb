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

  # Build books index URL with current filters and sorting
  # Excludes pagination and internal parameters
  def books_index_url_with_filters
    # Use @current_index_url if set by controller, otherwise build from request
    return @current_index_url if @current_index_url.present?

    # Get filter params from request (exclude internal params)
    filter_params = request.query_parameters.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method).to_h

    # Build URL with query parameters
    if filter_params.any?
      base_url = books_path
      query_string = filter_params.to_query
      "#{base_url}?#{query_string}"
    else
      books_path
    end
  end

  # Build members index URL with current filters and sorting
  # Excludes pagination and internal parameters
  def members_index_url_with_filters
    # Use @current_index_url if set by controller, otherwise build from request
    return @current_index_url if @current_index_url.present?

    # Get filter params from request (exclude internal params)
    filter_params = request.query_parameters.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method).to_h

    # Build URL with query parameters
    if filter_params.any?
      base_url = members_path
      query_string = filter_params.to_query
      "#{base_url}?#{query_string}"
    else
      members_path
    end
  end

  # Build loans index URL with current filters and sorting
  # Excludes pagination and internal parameters
  def loans_index_url_with_filters
    # Use @current_index_url if set by controller, otherwise build from request
    return @current_index_url if @current_index_url.present?

    # Get filter params from request (exclude internal params)
    filter_params = request.query_parameters.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method).to_h

    # Build URL with query parameters
    if filter_params.any?
      base_url = loans_path
      query_string = filter_params.to_query
      "#{base_url}?#{query_string}"
    else
      loans_path
    end
  end

  # Format date for display
  # Formats dates consistently across the application
  def format_date(date)
    return "N/A" if date.blank?

    if date.is_a?(Date)
      date.strftime("%b %d, %Y")
    elsif date.is_a?(Time) || date.is_a?(DateTime)
      # Check if time component is meaningful (not midnight)
      if date.hour == 0 && date.min == 0 && date.sec == 0
        date.strftime("%b %d, %Y")
      else
        date.strftime("%b %d, %Y %I:%M %p")
      end
    else
      date.to_s
    end
  end

  # Format time for display
  # Formats time values (Time objects) consistently
  def format_time(time)
    return "N/A" if time.blank?

    if time.is_a?(Time) || time.is_a?(DateTime)
      time.strftime("%I:%M %p")
    else
      time.to_s
    end
  end

  # Format metadata hash for display
  # Converts JSON hash to a readable format
  def format_metadata(metadata)
    return "N/A" if metadata.blank?

    # Handle both Hash (from JSON column) and JSON string
    metadata_hash = if metadata.is_a?(String)
      begin
        JSON.parse(metadata)
      rescue JSON::ParserError
        {}
      end
    elsif metadata.is_a?(Hash) || metadata.is_a?(ActiveSupport::HashWithIndifferentAccess)
      metadata.to_h
    else
      {}
    end

    return "N/A" if metadata_hash.empty?

    # Format as key-value pairs in a definition list
    content_tag(:dl, class: "space-y-2") do
      safe_join(metadata_hash.map do |key, value|
        content_tag(:div, class: "flex flex-wrap gap-2") do
          content_tag(:dt, "#{key.to_s.humanize}:", class: "font-semibold text-gray-700") +
          content_tag(:dd, value.to_s, class: "text-gray-900")
        end
      end)
    end
  end
end
