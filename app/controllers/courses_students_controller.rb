class CoursesStudentsController < ApplicationController
  before_action :set_courses_student, only: [:show, :edit, :update, :destroy]

  # GET /courses_students
  # GET /courses_students.json
  def index
    @courses_students = CoursesStudent.all
  end

  # GET /courses_students/1
  # GET /courses_students/1.json
  def show
  end

  # GET /courses_students/new
  def new
    @courses_student = CoursesStudent.new
  end

  # GET /courses_students/1/edit
  def edit
  end

  def update_note
    courses_student = CoursesStudent.find(params[:id].to_i)
    courses_student.note = params[:note]
    courses_student.save!
    respond_to do |format|
      format.json{render :json => {:status => 'Note successfully saved', :note => courses_student.note}}
    end
  end

  # POST /courses_students
  # POST /courses_students.json
  def create
    @courses_student = CoursesStudent.new(courses_student_params)

    respond_to do |format|
      if @courses_student.save
        format.html { redirect_to @courses_student, notice: 'Courses student was successfully created.' }
        format.json { render :show, status: :created, location: @courses_student }
      else
        format.html { render :new }
        format.json { render json: @courses_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses_students/1
  # PATCH/PUT /courses_students/1.json
  def update
    respond_to do |format|
      if @courses_student.update(courses_student_params)
        format.html { redirect_to @courses_student, notice: 'Courses student was successfully updated.' }
        format.json { render :show, status: :ok, location: @courses_student }
      else
        format.html { render :edit }
        format.json { render json: @courses_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses_students/1
  # DELETE /courses_students/1.json
  def destroy
    @courses_student.destroy
    respond_to do |format|
      format.html { redirect_to courses_students_url, notice: 'Courses student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_courses_student
      @courses_student = CoursesStudent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def courses_student_params
      params.require(:courses_student).permit(:courses_id, :students_id, :answered, :passed, :absent, :note)
    end
end
