class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :institution
  has_many :course_jobs
  has_many :jobs, :through => :course_jobs
end
