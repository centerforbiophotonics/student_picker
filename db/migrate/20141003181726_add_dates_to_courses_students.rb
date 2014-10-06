class AddDatesToCoursesStudents < ActiveRecord::Migration
  def change
    change_table(:courses_students) do |t|
      t.date :answered_dates, :array => true, :default => []
      t.date :passed_dates, :array => true, :default => []
      t.date :absent_dates, :array => true, :default => []
    end
  end
end
