class Job < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :couse_job
  belongs_to :course, :through => :course_job
end
