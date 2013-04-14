class Job < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :course_jobs
  has_many :courses, :through => :course_jobs
  has_many :job_tags
end
