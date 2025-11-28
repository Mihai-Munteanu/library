class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Filterable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # def record_not_found
  #   render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  # end

  # def routing_error
  #   render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  # end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
