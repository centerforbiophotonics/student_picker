class CreateCoursesStudents < ActiveRecord::Migration
  def change
    create_table :courses_students do |t|
      t.references :courses, index: true
      t.references :students, index: true
      t.integer :answered, :default => 0
      t.integer :passed, :default => 0
      t.integer :absent, :default => 0
      t.string :note

      t.timestamps
    end
  end
end
