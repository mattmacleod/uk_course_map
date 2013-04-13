class Course < ActiveRecord::Base
  attr_protected
  belongs_to :institution
  has_many :course_jobs
  has_many :jobs, :through => :course_jobs
end
