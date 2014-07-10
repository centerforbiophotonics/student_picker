class CoursesStudent < ActiveRecord::Base
  belongs_to :courses
  belongs_to :students
end
