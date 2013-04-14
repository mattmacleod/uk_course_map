class Job < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :course_jobs
  has_many :courses, :through => :course_jobs
  has_many :job_tags

  def self.tagged_with(tag)
  	JobTag.where(["tag LIKE ?", "%#{tag}%"]).map(&:job)
  end

end
