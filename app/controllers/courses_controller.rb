class CoursesController < ApplicationController
	
	def create
		@user = User.find(params[:user_id])
		@course = @user.courses.create(courses_params)
		redirect_to user_path(@user)
	end
	
	private
		def course_params
			params.require(:course).permit(:name)
		end
end
