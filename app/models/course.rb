class Course < ActiveRecord::Base
  belongs_to :user
  has_many :courses_students, :foreign_key => "courses_id"
  has_many :students, :through => :courses_students
  validates :name, presence: true
  accepts_nested_attributes_for :user, :allow_destroy => true
end
