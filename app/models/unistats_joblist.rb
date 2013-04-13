class UnistatsJoblist < ActiveRecord::Base
	establish_connection(:unistats)
	set_table_name :joblist
	set_primary_key :recordId

	belongs_to :unistats_course, :foreign_key => "parentId"

	def self.import!

	    courses = Course.all.inject({}) { |acc,val| acc[val.kis_course_id] = val.id; acc }

		self.includes(:unistats_course).all.each do |external_job|

			job = Job.find_or_create_by_title(external_job.JOB)
			job.save!
			
			course_job = CourseJob.find_or_create_by_job_id_and_course_id job.id, courses[external_job.unistats_course.KISCOURSEID]
			course_job.percentage = external_job.PERC
			course_job.save!

		end

	end

end
