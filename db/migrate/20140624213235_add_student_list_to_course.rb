class AddStudentListToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :student_list, :string
  end
end
