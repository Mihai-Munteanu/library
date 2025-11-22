class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.order(created_at: :desc)
    @pagy, @books = pagy(:offset, @books)
  end

  def show
  end

  def new
    @book = Book.new(pages:0, copies_sold:0, price:0.00)
  end

  def edit
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
    if @book.update(book_params)
      redirect_to @book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    flash.now[:notice] = "Book deleted successfully"
    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book deleted successfully" }
      format.turbo_stream
    end
  end

  private

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
      :pages
    )
  end

end
