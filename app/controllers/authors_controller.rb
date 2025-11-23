class AuthorsController < ApplicationController
  before_action :set_author, only: [ :show, :edit, :update, :destroy ]

  def index
    @authors = Author.all
    @authors = apply_filters(@authors, [ :name, :nationality, :gender ])
    @authors = apply_sorting(@authors, { created_at: :desc })
    @pagy, @authors = pagy(:offset, @authors, items: 10)
  end

  def show
    @author = Author.includes(:books).find(params[:id])
    @books = @author.books
    @pagy, @books = pagy(:offset, @books, items: 10)
  end

  def new
    @author = Author.new
  end

  def edit
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
    flash.now[:notice] = "Author deleted successfully"
    respond_to do |format|
      format.html { redirect_to authors_path, notice: "Author deleted successfully" }
      format.turbo_stream
    end
  end

  private

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
      :awards,
      :publications,
      :achievements
    )
  end
end
