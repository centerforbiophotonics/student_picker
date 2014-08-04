class CoursesController < ApplicationController
  require 'csv'

  def create #TODO: figure out what calls to save! are redundant
    puts params.inspect
    @user = User.find(params[:user_id])
    @course = @user.courses.new
    @course.name = params[:course][:name]
    @course.save!

    if(params[:course][:student_list].present?)
      CSV.foreach(params[:course][:student_list].path, {:headers => true}) do |row|
       student = Student.new
       student.name = row["Name"]
       student.sid = row["User ID"]
       student.save!
       courses_student = CoursesStudent.new(:courses_id=>@course.id, :students_id=>student.id)
       courses_student.save!
      end
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

    #Update course name
    @course.name = params[:course][:name]

    #Add new students or update existing students if found in the roster
    sid_array = []
    CSV.foreach(params[:course][:student_list].path, {:headers => true}) do |row|
     sid_array << row["User ID"].to_i
     student = Student.where(:sid => row["User ID"]).first
     if(!student.present?)
       student = Student.new
       student.name = row["Name"]
       student.sid = row["User ID"]
       student.save!
       courses_student = CoursesStudent.new(:courses_id=>@course.id, :students_id=>student.id)
       courses_student.save!
     else
       student.name = row["Name"]
       student.sid = row["User ID"]
       student.save!
     end 
    end

    #Destroy students who are not present in the new roster
    Student.
      joins(:courses_student).
      where("courses_id = #{@course.id}").
      where("sid not in (#{sid_array.to_s.gsub('[','').gsub(']','')})").
      destroy_all

    respond_to do |format|
      format.js { render :js => "window.location.href='"+user_path(@course.user_id)+"'"}
      format.html { redirect_to @course.user }
      #format.json { head :no_content }
    end
  end

  def answer
  	course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first 

    courses_students.answered += 1
    courses_students.save! 
  	course.save!
    respond_to do |format|
  	    format.json do
          render :json => {name: params[:student][:name], value: courses_students.answered }
        end
     end
  end

  def absent
    course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first
    courses_students.absent += 1
    courses_students.save!
    course.save!
    respond_to do |format|
        format.json do
          render :json => {name: params[:student][:name], value: courses_students.absent }
        end
     end    
  end

  def pass
    puts params.inspect
    course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first
    courses_students.passed += 1
    courses_students.save!
    course.save!
    respond_to do |format|
        format.json do
         render :json => {name: params[:student][:name], value: courses_students.passed} 
       end
     end
  end
	
	private
		def course_params
			params.require(:course).permit(:name, :student_list)
		end
	end
