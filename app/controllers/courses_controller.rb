class CoursesController < ApplicationController
  require 'csv'
	def create
    puts params.inspect
		@user = User.find(params[:user_id])
		@course = @user.courses.new

    CSV.foreach(params[:course][:student_list].path, {:headers => true}) do |row|
      student = Student.new
      student.name = row["Name"]
      student.sid = row["User ID"]
      student.save!
      courses_student = CoursesStudent.new(:courses_id=>@course.id, :students_id=>student.id)
      courses_student.save!
    end
		@course.save!
    @user.save!
		redirect_to user_path(@user)
	end
  
  def show
  		@course = Course.find params[:id]
  end

  def destroy
	puts params.inspect
	@course = Course.find params[:id]
    @course.destroy
    respond_to do |format|
      format.html { redirect_to @course.user}
      format.json { head :no_content }
    end
  end
  
  def edit
	@course = Course.find params[:id]
  end
  
  def update
	@course = Course.find params[:id]
    @course.update(course_params)

    #render :nothing => true
    #redirect_to users_url, notice: 'Course was successfully updated.'
    respond_to do |format|
      format.js { render :js => "window.location.href='"+user_path(@course.user_id)+"'"}
      #format.json { head :no_content }
    end
  end

  def answer
  	puts params.inspect
  	course = Course.find params[:id]
  	student_list = JSON.parse(course.student_list)
  	student_list[params[:student]]["answer"] += 1
  	course.student_list = student_list.to_json
  	course.save!
    respond_to do |format|
  	     format.json do
          render :json => {name: params[:student], value: student_list[params[:student]]["answer"]}.to_json #, status: "success"
        end
      end
  end

  def absent
    puts params.inspect
    course = Course.find params[:id]
    student_list = JSON.parse(course.student_list)
    student_list[params[:student]]["absent"] += 1
    course.student_list = student_list.to_json
    course.save!
    respond_to do |format|
         format.json do
          render :json => {name: params[:student], value: student_list[params[:student]]["absent"]}.to_json #, status: "success"
        end
      end    
  end

  def pass
    puts params.inspect
    course = Course.find params[:id]
    student_list = JSON.parse(course.student_list)
    student_list[params[:student]]["pass"] += 1
    course.student_list = student_list.to_json
    course.save!
    respond_to do |format|
         format.json do
          render :json => {name: params[:student], value: student_list[params[:student]]["pass"]}.to_json 
        end
      end
  end
	
	private
		def course_params
			params.require(:course).permit(:name, :student_list)
		end
	end
