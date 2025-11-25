class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy delete_confirmation ]

  # GET /loans or /loans.json
  def index
    @loans = Loan.includes(:member, :book).all
    @loans = apply_filters(@loans, [:member_id, :book_id, :status])
    @loans = apply_sorting(@loans, { created_at: :desc })
    @pagy, @loans = pagy(:offset, @loans, items: 10)
  end

  # GET /loans/1 or /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
  end

  # GET /loans/1/edit
  def edit
  end

  def delete_confirmation
    render layout: false
  end

  # POST /loans or /loans.json
  def create
    @loan = Loan.new(loan_params)

    respond_to do |format|
      if @loan.save
        format.html { redirect_to @loan, notice: "Loan was successfully created." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1 or /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: "Loan was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1 or /loans/1.json
  def destroy
    redirect_to = params[:redirect_to]
    from_page = params[:from_page]
    @book = @loan.book if from_page == "book_show"

    @loan.destroy!

    respond_to do |format|
      format.html { redirect_to redirect_to.presence || loans_path, notice: "Loan was successfully destroyed.", status: :see_other }
      format.turbo_stream do
        if from_page == "book_show" && @book.present?
          # From book show page: reload the book's loans
          @loans = @book.loans
          @loans = apply_sorting(@loans, { created_at: :desc })
          @pagy, @loans = pagy(:offset, @loans, items: 10)

          render :destroy
        else
          # From loans index or other pages
          render :destroy
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.expect(loan: [
        :member_id,
        :book_id,
        :start_date,
        :due_date,
        :return_date,
        :status,
        :notes,
        :metadata,
        :paused_start_time,
        :paused_end_time
      ])
    end
end
