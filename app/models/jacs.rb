class Jacs < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :course_jobs
end
