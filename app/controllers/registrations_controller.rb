class RegistrationsController < Devise::RegistrationsController
	prepend_view_path "app/views/devise"
	def create
		puts params
		super
	end
end