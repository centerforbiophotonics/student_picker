class Course < ActiveRecord::Base
  belongs_to :user
  has_many :courses_students
  has_many :students, :through => :courses_students
  validates :name, presence: true
  accepts_nested_attributes_for :user, :allow_destroy => true
end
