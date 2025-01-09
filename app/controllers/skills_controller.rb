class SkillsController < ApplicationController
  before_action :set_skill, only: %i[ show edit update destroy ]

  # GET /skils or /skils.json
  def index
    @skills = Skill.all
  end

  # GET /skils/1 or /skils/1.json
  def show
  end

  # GET /skils/new
  def new
    @skill = Skill.new
  end

  # GET /skils/1/edit
  def edit
  end

  # POST /skils or /skils.json
  def create
    @skill = Skill.new(skil_params)

    respond_to do |format|
      if @skill.save
        format.html { redirect_to @skill, notice: "Skill was successfully created." }
        format.json { render :show, status: :created, location: @skill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skils/1 or /skils/1.json
  def update
    respond_to do |format|
      if @skill.update(skil_params)
        format.html { redirect_to @skill, notice: "Skill was successfully updated." }
        format.json { render :show, status: :ok, location: @skill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skils/1 or /skils/1.json
  def destroy
    @skill.destroy!

    respond_to do |format|
      format.html { redirect_to skils_path, status: :see_other, notice: "Skill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.expect(skill: [ :name, :user_id ])
    end
end
