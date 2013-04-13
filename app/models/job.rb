class Job < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :couse_job
  has_one :course, :through => :course_job
end
