class BooksController < ApplicationController
  before_action :set_book, only: [ :show, :edit, :update, :destroy, :delete_confirmation ]

  def index
    load_books
  end

  def show
    @book = Book.includes(:author, :loans).find(params[:id])
    @loans = @book.loans
    @loans = apply_sorting(@loans, { created_at: :desc })
    @pagy, @loans = pagy(@loans, limit: 10)
  end

  def new
    @book = Book.new(pages: 0, copies_sold: 0, price: 0.00)
    # Preselect author if author_id parameter is provided (e.g., from author show page)
    @book.author_id = params[:author_id] if params[:author_id].present?
  end

  def edit
  end

  def delete_confirmation
    render layout: false
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Handle cover removal if checkbox is checked
    if params[:book] && params[:book][:remove_cover] == "1"
      @book.cover.purge if @book.cover.attached?
    end

    update_params = book_params
    update_params.delete(:remove_cover) if update_params.key?(:remove_cover)

    if @book.update(update_params)
      redirect_to @book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to = params[:redirect_to]
    from_page = params[:from_page]

    respond_to do |format|
      format.html { redirect_to redirect_to.presence || books_path, notice: "Book deleted successfully" }
      format.turbo_stream do
        if from_page == "author_show"
          # From author show page: reload the author's books table
          @author = @book.author
          @books = @author.books
          @books = apply_sorting(@books, { created_at: :desc })
          @pagy, @books = pagy(@books, limit: 5)

          render :destroy
        elsif from_page == "show" && redirect_to.present?
          # From book show page: redirect to index
          redirect_to redirect_to, notice: "Book deleted successfully"
        elsif from_page == "index"
          # From index page: reload books with same filters/sorting to update the list
          load_books

          render :destroy
        else
          # Fallback: render turbo_stream template
          render :destroy
        end
      end
    end
  end

  private

  def load_books
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
      base_url = books_path
      query_string = filter_hash.to_query
      @current_index_url = "#{base_url}?#{query_string}"
    else
      @current_index_url = books_path
    end

    @books = Book.includes(:author, loans: :member).all
    @books = apply_filters(@books, [ :title, :isbn, :author_id ])
    @books = apply_sorting(@books, { created_at: :desc })
    @pagy, @books = pagy(@books, limit: 10)
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      :title,
      :isbn,
      :description,
      :author_id,
      :publication_date,
      :copies_sold,
      :price,
      :pages,
      :cover,
      :remove_cover
    )
  end
end
