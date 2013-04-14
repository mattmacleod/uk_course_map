class CreateJobTags < ActiveRecord::Migration
  def change
    create_table :job_tags do |t|
      t.integer :job_id
      t.string :tag
    end
  end
end
