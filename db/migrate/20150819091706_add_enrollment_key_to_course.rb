class AddEnrollmentKeyToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :enrollment_key, :string
  end
end
