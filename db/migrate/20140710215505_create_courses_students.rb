class CreateCoursesStudents < ActiveRecord::Migration
  def change
    create_table :courses_students do |t|
      t.references :courses, index: true
      t.references :students, index: true
      t.integer :answered
      t.integer :passed
      t.integer :absent
      t.string :note

      t.timestamps
    end
  end
end
