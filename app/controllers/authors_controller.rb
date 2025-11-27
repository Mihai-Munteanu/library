class AuthorsController < ApplicationController
  before_action :set_author, only: [ :show, :edit, :update, :destroy, :delete_confirmation ]

  def index
    load_authors
  end

  def show
    @author = Author.includes(:books).find(params[:id])
    @books = @author.books
    @books = apply_sorting(@books, { created_at: :desc })
    @pagy, @books = pagy(:offset, @books, limit: 5)

    # If this is a Turbo Frame request (pagination), render only the frame partial
    if request.headers["Turbo-Frame"] == "books_table"
      render partial: "authors/books_table_frame", layout: false
      nil
    end
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def delete_confirmation
    render layout: false
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to @author
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    redirect_to = params[:redirect_to]
    from_page = params[:from_page]

    respond_to do |format|
      format.html { redirect_to redirect_to.presence || authors_path, notice: "Author deleted successfully" }
      format.turbo_stream do
        if from_page == "show" && redirect_to.present?
          # From show page: redirect to index
          redirect_to redirect_to, notice: "Author deleted successfully"
        elsif from_page == "index"
          # From index page: reload authors with same filters/sorting to update the list
          # Filter and sort params are already in params (passed through the form)
          # Exclude internal params (we exclude :page to let Pagy recalculate)
          # The params already contain the filter/sort values from the form submission

          # Reload authors using the same logic as index action
          # This will preserve filters (name, nationality, gender) and sorting (sort, direction)
          # apply_filters and apply_sorting read directly from params
          load_authors

          render :destroy
        else
          # Fallback: render turbo_stream template
          render :destroy
        end
      end
    end
  end

  private

  def load_authors
    # Get filters and sorting from URL/request parameters
    # Use request.query_parameters if available (from URL), otherwise fallback to params (from form)
    source_params = request.query_parameters.present? ? request.query_parameters : params

    # Temporarily merge query params into params so apply_filters and apply_sorting can use them
    # Exclude internal params
    filter_params = source_params.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method)
    filter_params.each { |k, v| params[k] = v if v.present? }

    # Build current URL with filters/sorting for use in views (for delete links, etc.)
    # This ensures filters persist in links after Turbo Stream updates
    # Convert to hash and build URL (filter_params might be HashWithIndifferentAccess or Parameters)
    filter_hash = filter_params.is_a?(ActionController::Parameters) ? filter_params.to_unsafe_h : filter_params.to_h
    filter_hash = filter_hash.compact

    # Build URL with query parameters properly encoded
    # Use string concatenation to avoid route parameter confusion
    if filter_hash.any?
      base_url = authors_path
      query_string = filter_hash.to_query
      @current_index_url = "#{base_url}?#{query_string}"
    else
      @current_index_url = authors_path
    end

    @authors = Author.all
    @authors = apply_filters(@authors, [ :name, :nationality, :gender ])
    @authors = apply_sorting(@authors, { created_at: :desc })
    @pagy, @authors = pagy(:offset, @authors, limit: 10)
  end

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(
      :name,
      :biography,
      :birth_date,
      :death_date,
      :nationality,
      :gender,
      metadata: [ :website, :email, :twitter, :facebook, :tags, :notes ]
    )
  end
end
