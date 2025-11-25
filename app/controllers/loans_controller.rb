class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy delete_confirmation ]

  # GET /loans or /loans.json
  def index
    load_loans
  end

  # GET /loans/1 or /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    # Set default start date to today and due date to 14 days from today
    @loan.start_date = Date.today
    @loan.due_date = Date.today + 14.days
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
    # Set default status to borrowed when creating a new loan
    @loan.status ||= :borrowed

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
    @member = @loan.member if from_page == "member_show"

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
        elsif from_page == "member_show" && @member.present?
          # From member show page: reload the member's loans
          @loans = @member.loans
          @loans = apply_sorting(@loans, { created_at: :desc })
          @pagy, @loans = pagy(:offset, @loans, items: 10)

          render :destroy
        elsif from_page == "index"
          # From index page: reload loans with same filters/sorting to update the list
          load_loans

          render :destroy
        else
          # From loans index or other pages
          render :destroy
        end
      end
    end
  end

  private

  def load_loans
    # Get filters and sorting from URL/request parameters
    source_params = request.query_parameters.present? ? request.query_parameters : params

    # Temporarily merge query params into params so apply_filters and apply_sorting can use them
    filter_params = source_params.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method)
    filter_params.each { |k, v| params[k] = v if v.present? }

    # Build current URL with filters/sorting for use in views
    filter_hash = filter_params.is_a?(ActionController::Parameters) ? filter_params.to_unsafe_h : filter_params.to_h
    filter_hash = filter_hash.compact

    if filter_hash.any?
      base_url = loans_path
      query_string = filter_hash.to_query
      @current_index_url = "#{base_url}?#{query_string}"
    else
      @current_index_url = loans_path
    end

    @loans = Loan.includes(:member, :book).all
    @loans = apply_filters(@loans, [ :member_id, :book_id, :status ])
    @loans = apply_sorting(@loans, { created_at: :desc })
    @pagy, @loans = pagy(:offset, @loans, items: 10)
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      loan_params = params.expect(loan: [
        :member_id,
        :book_id,
        :start_date,
        :due_date,
        :notes,
        { metadata: {} }
      ])

      # Clean up metadata hash - remove empty values
      if loan_params[:metadata].present?
        loan_params[:metadata] = loan_params[:metadata].compact_blank
      end

      loan_params
    end
end
