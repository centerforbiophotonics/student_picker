class Course < ActiveRecord::Base
  belongs_to :user
  has_many :courses_students, :foreign_key => "courses_id"
  has_many :students, :through => :courses_students
  validates :name, :presence => true
  accepts_nested_attributes_for :user, :allow_destroy => true

  def to_csv
  	CSV.generate do |csv|
  		csv << ["Name", "SID", "Answered", "Answer Dates", "Absent", "Absent Dates", "Passed", "Passed Dates"]
  		students.each do |student|
        cs = student.courses_student.where(:courses_id => id).first
  			csv << [student.name,
  			  student.sid,
  			  cs.answered,cs.answered_dates,
  		      cs.absent,cs.absent_dates,
  		      cs.passed,cs.passed_dates]

  		end
  	end
  end
end
