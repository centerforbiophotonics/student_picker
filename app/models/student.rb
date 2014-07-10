class Student < ActiveRecord::Base
	has_many :courses_student
	has_many :courses, :through => :courses_student
end
