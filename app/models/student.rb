class Student < ActiveRecord::Base
	has_many :courses_student,:dependent => :delete_all, :foreign_key => "students_id"
	has_many :courses, :through => :courses_student
	validates :name, presence: true
	validates_uniqueness_of :sid
  accepts_nested_attributes_for :courses_student
end
