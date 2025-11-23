class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.all
    @members = apply_filters(@members, [:name, :email, :gender, :is_active, :is_vip])
    @members = apply_sorting(@members, { created_at: :desc })
    @pagy, @members = pagy(:offset, @members, items: 10)
  end

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
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
    flash.now[:notice] = "Member deleted successfully"

    respond_to do |format|
      format.html { redirect_to members_path, notice: "Member deleted successfully" }
      format.turbo_stream
    end
  end

  private
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
