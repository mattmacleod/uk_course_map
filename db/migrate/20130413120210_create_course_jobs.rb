class CreateCourseJobs < ActiveRecord::Migration
  def change
    create_table :course_jobs do |t|
      t.integer :course_id
      t.integer :job_id
      t.integer :percentage
      t.timestamps
    end
  end
end
