class CoursesController < ApplicationController
	
	def create
		@user = User.find(params[:user_id])
		@course = @user.courses.create(course_params)
		student_list = {}
		course_params[:student_list].split(/[,\t]+/).each do |student_name|
			student_list[student_name]	= {
				:answer => 0,
				:absent => 0,
				:pass => 0
			}
		end
		@course.student_list = student_list.to_json()
		@course.save!
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
