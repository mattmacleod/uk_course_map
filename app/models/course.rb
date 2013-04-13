class Course < ActiveRecord::Base
  attr_protected
  belongs_to :institution
  has_many :course_jobs
  has_many :jobs, :through => :course_jobs
  has_and_belongs_to_many :jacs_codes

  def job_weights
  	jobs.select([:percentage, "jobs.id"]).map { |j| {j.id => j.percentage} }
  end

end
