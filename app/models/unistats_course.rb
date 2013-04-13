class UnistatsCourse < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :kiscourse
  set_primary_key :KISCOURSEID

  def self.import!

    institutions = Institution.all.inject({}) { |acc,val| acc[val.unistats_id.to_s] = val; acc }

    self.all.each do |external_course|

      course = Course.find_or_create_by_kis_course_id external_course.KISCOURSEID

      institution = institutions[ external_course.parentId.to_s ]

      course.attributes = {
        :institution_id => institution.id
      }

      course.save!

    end

  end

end
