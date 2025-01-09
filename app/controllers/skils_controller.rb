class SkilsController < ApplicationController
  before_action :set_skil, only: %i[ show edit update destroy ]

  # GET /skils or /skils.json
  def index
    @skils = Skil.all
  end

  # GET /skils/1 or /skils/1.json
  def show
  end

  # GET /skils/new
  def new
    @skil = Skil.new
  end

  # GET /skils/1/edit
  def edit
  end

  # POST /skils or /skils.json
  def create
    @skil = Skil.new(skil_params)

    respond_to do |format|
      if @skil.save
        format.html { redirect_to @skil, notice: "Skil was successfully created." }
        format.json { render :show, status: :created, location: @skil }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skils/1 or /skils/1.json
  def update
    respond_to do |format|
      if @skil.update(skil_params)
        format.html { redirect_to @skil, notice: "Skil was successfully updated." }
        format.json { render :show, status: :ok, location: @skil }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skils/1 or /skils/1.json
  def destroy
    @skil.destroy!

    respond_to do |format|
      format.html { redirect_to skils_path, status: :see_other, notice: "Skil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skil
      @skil = Skil.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def skil_params
      params.expect(skil: [ :name, :user_id ])
    end
end
