class Student < ActiveRecord::Base
	has_many :courses_student,:dependent => :delete_all, :foreign_key => "students_id"
	has_many :courses, :through => :courses_student
end
