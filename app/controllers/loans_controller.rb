class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy ]

  # GET /loans or /loans.json
  def index
    @loans = Loan.all
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
    @loan.destroy!

    respond_to do |format|
      format.html { redirect_to loans_path, notice: "Loan was successfully destroyed.", status: :see_other }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("loan_#{@loan.id}") }
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
