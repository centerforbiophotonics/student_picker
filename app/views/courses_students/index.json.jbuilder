json.array!(@courses_students) do |courses_student|
  json.extract! courses_student, :id, :courses_id, :students_id, :answered, :passed, :absent, :note
  json.url courses_student_url(courses_student, format: :json)
end
