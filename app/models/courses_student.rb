class CoursesStudent < ActiveRecord::Base
  belongs_to :course, :foreign_key => "courses_id"
  belongs_to :student, :foreign_key => "students_id"
end
