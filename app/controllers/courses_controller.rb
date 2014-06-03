class CoursesController < ApplicationController
	
	def create
		@user = User.find(params[:user_id])
		@course = @user.courses.create(course_params)
		redirect_to user_path(@user)
	end
	
	def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
	
	private
		def course_params
			params.require(:course).permit(:name)
		end
end
