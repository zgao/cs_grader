class AddCourseIdToCsClasses < ActiveRecord::Migration
  def change
    add_column :cs_classes, :course_id, :integer
  end
end
