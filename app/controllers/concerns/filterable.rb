# Concern for adding filtering and sorting capabilities to controllers
module Filterable
  extend ActiveSupport::Concern

  private

  # Apply filters to a collection based on params
  def apply_filters(collection, filterable_columns)
    filtered = collection
    model_class = collection.model

    filterable_columns.each do |column|
      if params[column].present?
        value = params[column]

        # Handle different column types
        case column.to_s
        when /_id$/
          # Foreign key filters
          filtered = filtered.where(column => value)
        when /_date$/, /_at$/
          # Date filters - support range or exact match
          if value.is_a?(Hash) && value[:from].present? && value[:to].present?
            filtered = filtered.where("#{column} >= ? AND #{column} <= ?", value[:from], value[:to])
          elsif value.present?
            filtered = filtered.where(column => value)
          end
        when /is_/
          # Boolean filters
          filtered = filtered.where(column => ActiveModel::Type::Boolean.new.cast(value))
        else
          # Check if column is an enum
          if model_class.respond_to?(:defined_enums) && model_class.defined_enums[column.to_s]
            # Enum filter - convert enum key to integer value
            # Try both string and symbol keys
            enum_hash = model_class.defined_enums[column.to_s]
            enum_value = enum_hash[value] || enum_hash[value.to_sym]
            if enum_value
              filtered = filtered.where(column => enum_value)
            end
          else
            # String filters - case-insensitive search (works with SQLite and PostgreSQL)
            filtered = filtered.where("LOWER(#{column}) LIKE ?", "%#{value.downcase}%")
          end
        end
      end
    end

    filtered
  end

  # Apply sorting to a collection
  def apply_sorting(collection, default_sort = { created_at: :desc })
    sort_column = params[:sort]&.to_sym || default_sort.keys.first
    sort_direction = params[:direction]&.to_sym || default_sort.values.first

    # Validate sort column exists in the model
    if collection.model.column_names.include?(sort_column.to_s)
      collection.order(sort_column => sort_direction)
    else
      collection.order(default_sort)
    end
  end

  # Generate sort link URL
  def sort_link(column, label, current_path)
    direction = if params[:sort] == column.to_s && params[:direction] == "asc"
      "desc"
    else
      "asc"
    end

    link_to label,
            url_for(params.permit!.merge(sort: column, direction: direction)),
            class: "flex items-center space-x-1 hover:text-blue-600"
  end

  # Get current sort direction indicator
  def sort_indicator(column)
    return "" unless params[:sort] == column.to_s

    params[:direction] == "asc" ? "\u2191" : "\u2193"
  end
end
