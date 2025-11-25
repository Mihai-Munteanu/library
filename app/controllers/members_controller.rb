class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy delete_confirmation ]

  # GET /members or /members.json
  def index
    load_members
  end

  # GET /members/1 or /members/1.json
  def show
    @member = Member.includes(:loans).find(params[:id])
    @loans = @member.loans
    @loans = apply_sorting(@loans, { created_at: :desc })
    @pagy, @loans = pagy(:offset, @loans, items: 10)
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  def delete_confirmation
    render layout: false
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy!
    redirect_to = params[:redirect_to]
    from_page = params[:from_page]

    respond_to do |format|
      format.html { redirect_to redirect_to.presence || members_path, notice: "Member deleted successfully" }
      format.turbo_stream do
        if from_page == "show" && redirect_to.present?
          # From show page: redirect to index
          redirect_to redirect_to, notice: "Member deleted successfully"
        elsif from_page == "index"
          # From index page: reload members with same filters/sorting to update the list
          load_members

          render :destroy
        else
          # Fallback: render turbo_stream template
          render :destroy
        end
      end
    end
  end

  private

  def load_members
    # Get filters and sorting from URL/request parameters
    source_params = request.query_parameters.present? ? request.query_parameters : params

    # Temporarily merge query params into params so apply_filters and apply_sorting can use them
    filter_params = source_params.except(:page, :redirect_to, :from_page, :controller, :action, :id, :authenticity_token, :_method)
    filter_params.each { |k, v| params[k] = v if v.present? }

    # Build current URL with filters/sorting for use in views
    filter_hash = filter_params.is_a?(ActionController::Parameters) ? filter_params.to_unsafe_h : filter_params.to_h
    filter_hash = filter_hash.compact

    if filter_hash.any?
      base_url = members_path
      query_string = filter_hash.to_query
      @current_index_url = "#{base_url}?#{query_string}"
    else
      @current_index_url = members_path
    end

    @members = Member.all
    @members = apply_filters(@members, [:name, :email, :gender, :is_active, :is_vip])
    @members = apply_sorting(@members, { created_at: :desc })
    @pagy, @members = pagy(:offset, @members, items: 10)
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.expect(member: [
        :name,
        :email,
        :birth_date,
        :gender,
        :is_active,
        :is_vip,
        :is_admin,
        :balance,
        :total_spent,
        :discount_rate,
        :points,
        :books_borrowed,
        :books_returned
    ])
    end
end
