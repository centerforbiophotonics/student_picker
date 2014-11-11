class CoursesController < ApplicationController
  require 'csv'

  def create #TODO: figure out what calls to save! are redundant
    @user = User.find(params[:course][:user_id])
    @course = @user.courses.new
    @course.name = params[:course][:name]
    success = @course.save

    
    if(params[:course][:student_list].present?)
      CSV.foreach(params[:course][:student_list].path, {:headers => true}) do |row|
        unless row["Name"].blank?
           student = Student.new
           student.name = row["Name"]
           student.sid = row["User ID"]
           student.save!
           courses_student = CoursesStudent.new(:courses_id=>@course.id, :students_id=>student.id)
           courses_student.save!
        end
      end
    end

    respond_to do |format|
      if success
        puts "SUCCESSFUL SAVE"
        @user.save! 
        format.js { render :js => "window.location.href='"+user_path(@course.user_id)+"'"}
        format.html { redirect_to @course.user }
      else
        puts "SAVE FAILED"
        format.html { render :partial  => "form", :status => :unprocessable_entity } 
        format.json { render :json => @course.errors, :status => :unprocessable_entity}           
      end      
    end 
	end
  
  def show
    @course = Course.find(params[:id])
    respond_to do |format|
      format.csv { send_data @course.to_csv,   :type => 'text/csv; charset=iso-8859-1; header=present',
                  :disposition => "attachment; filename=student_participation_for_#{@course.name}.csv"}
      format.html {}
      #format.json { head :no_content }
    end
  end

  def destroy
    @course = Course.find params[:id]
      @user = @course.user
      @title = "Showing User: #{@user.name}" 
      @course.destroy
      respond_to do |format|
        format.html { redirect_to user_url(@user.id)}
        format.json { head :no_content }
    end
  end
  
  def edit
	  @course = Course.find params[:id]
  end
  
  def update
    @course = Course.find(params[:id])
    @course.name = params[:course][:name]
    #@course.save!

    #Add new students or update existing students if found in the roster
    if(params[:course][:student_list].present?)
      sid_array = []
      CSV.foreach(params[:course][:student_list].path, {:headers => true}) do |row|
        unless row["Name"].blank?
         sid_array << row["User ID"].to_i
         student = Student.where(:sid => row["User ID"]).first

          if(!student.present?)
           student = Student.new
          end

          student.name = row["Name"]
          student.sid = row["User ID"] 
          student.save!

          unless CoursesStudent.
                  where(:courses_id => @course.id).
                  where(:students_id => student.id).exists?
            courses_student = CoursesStudent.new(:courses_id=>@course.id, :students_id=>student.id)
            courses_student.save!
          end
        end
        #Destroy students who are not present in the new roster
        Student.
          joins(:courses_student).
          where("courses_id = #{@course.id}").
          where("sid not in (#{sid_array.to_s.gsub('[','').gsub(']','')})").
          destroy_all
      end
    end  
    respond_to do |format|
      if @course.save
        flash[:notice] = "#{@course.name} has been successfully updated"
        format.js { render :js => "window.location.href='"+user_path(@course.user_id)+"'"}
        format.html { redirect_to @course.user }
        #format.json { head :no_content }
      else  
        format.html { render :edit } 
        format.json { render :json => @course.errors, :status => :unprocessable_entity} 
      end
    end  
  end

  def answer
  	course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first

    courses_students.answered += 1

    courses_students.answered_dates.push(Date.parse(params[:date]))
    courses_students.answered_dates_will_change!

    #answered_dates
    courses_students.save! 
  	course.save!
    respond_to do |format|
  	    format.json do
          render :json => {
              :id => params[:student][:id],
              :value => courses_students.answered,
              :date => courses_students.answered_dates.last,
              :key => params[:key]
          }
        end
     end
  end

  def absent
    course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first

    courses_students.absent += 1

    courses_students.absent_dates.push(Date.parse(params[:date]))
    courses_students.absent_dates_will_change!

    courses_students.save!
    course.save!
    respond_to do |format|
        format.json do
          render :json => {
              :id => params[:student][:id],
              :value => courses_students.absent,
              :date => courses_students.absent_dates.last,
              :key => params[:key]
          }
        end
     end    
  end

  def pass
    course = Course.find params[:id]
    courses_students = course.courses_students.where(:students_id => params[:student][:id]).first

    courses_students.passed += 1

    courses_students.passed_dates.push(Date.parse(params[:date]))
    courses_students.passed_dates_will_change!

    courses_students.save!
    course.save!
    respond_to do |format|
        format.json do
          render :json => {
              :id => params[:student][:id],
              :value => courses_students.passed,
              :date => courses_students.passed_dates.last,
              :key => params[:key]
          }
       end
     end
  end
	
	private
		def course_params
			params.require(:course).permit(:name, :student_list)
		end
	end
