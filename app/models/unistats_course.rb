class UnistatsCourse < ActiveRecord::Base
	establish_connection(:unistats)
	set_table_name :kiscourse
	set_primary_key :recordId

	has_one :unistats_continuation, :foreign_key => "parentId"

	def self.import!

		institutions = Institution.all.inject({}) { |acc,val| acc[val.unistats_id.to_s] = val; acc }

		self.includes(:unistats_continuation).all.each do |external_course|

			course = Course.find_or_create_by_kis_course_id(external_course.KISCOURSEID)

			institution = institutions[ external_course.parentId.to_s ]

			study_modes = {
				1 => "Full time",
				2 => "Part time"
			}

			strtobool = {
				1 => true,
				0 => false
			}

			continuation = external_course.unistats_continuation

			course.attributes = {
				:institution_id => institution.id,
				:ucas_code => external_course.UCASCOURSEID,
				
				:url_course => external_course.CRSEURL,
				:url_financial_support => external_course.SUPPORTURL,
				:url_employment => external_course.EMPLOYURL,
				:url_teaching => external_course.LTURL,
				
				:study_mode => study_modes[external_course.MODE],
				
				:has_means_tested_support => strtobool[external_course.MEANSSUP],
				:has_other_support => strtobool[external_course.OTHSUP],
				
				:fees_scotland => external_course.SCOTFEE.presence,
				:fees_england => external_course.ENGFEE.presence,
				:fees_wales => external_course.WAFEE.presence,
				:fees_ireland => external_course.NIFEE.presence,

				:success_first_year_dropout => (100-continuation.UCONT.to_i if continuation),
				:success_full => (continuation.UGAINED.to_i if continuation),
				:success_partial => (continuation.ULOWER.to_i if continuation),
				:success_failure => (continuation.ULEFT.to_i if continuation),
				
				# :outcome_work => external_course.,
				# :outcome_study => external_course.,
				# :outcome_unemployed => external_course.,
				
				# :qualification_access => external_course.,
				# :qualification_a_level => external_course.,
				# :qualification_bacc => external_course.,
				# :qualification_degree => external_course.,
				# :qualification_foundation => external_course.,
				# :qualification_none => external_course.,
				# :qualification_other => external_course.,
				# :qualification_other_he => external_course.,
				
				# :nss_teaching => external_course.,
				# :nss_feedback => external_course.,
				# :nss_academic => external_course.,
				# :nss_resources => external_course.,
				# :nss_personal_development => external_course.,
				
				# :salary_subject_average => external_course.,
				# :salary_course_average => tst
			}

			course.save!

		end

	end

end
