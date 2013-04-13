class UnistatsJac < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :jacs
  set_primary_key :recordId

  belongs_to :unistats_course, :foreign_key => "parentId"

  def self.import!

    courses = Course.all.inject({}) { |acc,val| acc[val.kis_course_id] = val; acc }
    
	self.includes(:unistats_course).all.each do |external_jacs|
		local_jacs_code = JacsCode.find_by_jacs_code external_jacs.JACS
		courses[ external_jacs.unistats_course.KISCOURSEID ].jacs_codes << local_jacs_code if local_jacs_code
	end

  end

end
