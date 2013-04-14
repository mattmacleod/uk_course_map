class Tag < ActiveRecord::Base

	def self.import!
		all.each do |tag|

			job = Job.find_by_title( tag.JOB )
			next unless job

			tags = tag.TAG.to_s.strip.split(",").map(&:strip).select(&:present?)
			tags.each do |t|
				JobTag.create :job => job, :tag => t
			end

		end
	end

end