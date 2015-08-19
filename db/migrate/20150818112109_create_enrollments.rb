class CreateEnrollments < ActiveRecord::Migration
  def up
    create_table :enrollments do |t|
      t.references :user, null: false
      t.references :course, null: false

      t.timestamps
    end

    add_index :enrollments, [:user_id, :course_id], unique: true
    add_foreign_key :enrollments, :courses, dependent: :delete
    add_foreign_key :enrollments, :users, dependent: :delete

    Course.all.each do |course|
      User.course_students(course).each do |user|
        Enrollment.create!(user: user, course: course)
      end
    end
  end

  def down
    Enrollment.destroy_all
    drop_table :enrollments
  end
end
