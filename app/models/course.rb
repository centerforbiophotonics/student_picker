class Course < ActiveRecord::Base
  belongs_to :user
  has_many :courses_students, :foreign_key => "courses_id"
  has_many :students, :through => :courses_students
  validates :name, :presence => true
  accepts_nested_attributes_for :user, :allow_destroy => true

  def to_csv
  	CSV.generate do |csv|
  		csv << ["Name", "SID", "Answered", "Absent", "Passed"]
  		students.each do |student|
  			csv << [student.name,
  			  student.sid,
  			  student.courses_student.where(:courses_id => id).first.answered,
  		      student.courses_student.where(:courses_id => id).first.absent,
  		      student.courses_student.where(:courses_id => id).first.passed]
  		end
  	end
  end
end
