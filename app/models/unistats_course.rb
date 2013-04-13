class UnistatsCourse < ActiveRecord::Base
	establish_connection(:unistats)
	set_table_name :kiscourse
	set_primary_key :recordId

	has_one :unistats_continuation, :foreign_key => "parentId"
	has_one :unistats_employment, :foreign_key => "parentId"
	has_one :unistats_entry, :foreign_key => "parentId"
	has_one :unistats_nss, :foreign_key => "parentId"
	has_one :unistats_salary, :foreign_key => "parentId"

	def self.import!

		institutions = Institution.all.inject({}) { |acc,val| acc[val.unistats_id.to_s] = val; acc }

		self.includes(:unistats_continuation, :unistats_employment, :unistats_entry, :unistats_nss).all.each do |external_course|

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
			employment = external_course.unistats_employment
			entry = external_course.unistats_entry
			nss = external_course.unistats_nss
			salary =  external_course.unistats_salary

			nss_teaching = ([:Q1, :Q2, :Q3, :Q4].map{|m| nss.send(m).to_i}._average) if nss
			nss_feedback = ([:Q5, :Q6, :Q7, :Q8, :Q9].map{|m| nss.send(m).to_i}._average) if nss
			nss_academic = ([:Q10, :Q11, :Q12].map{|m| nss.send(m).to_i}._average) if nss
			nss_resources = ([:Q16, :Q17, :Q18].map{|m| nss.send(m).to_i}._average) if nss
			nss_personal_development = ([:Q19].map{|m| nss.send(m).to_i}._average) if nss

			course.attributes = {
				
				:title => external_course.TITLE,

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
				
				:outcome_work => (employment.WORK.to_i if employment),
				:outcome_study => (employment.STUDY.to_i if employment),
				:outcome_unemployed => (employment.ASSUNEMP.to_i if employment),
				
				:qualification_access => (entry.ACCESS.to_i if entry),
				:qualification_a_level => (entry.ALEVEL.to_i if entry),
				:qualification_bacc => (entry.BACC.to_i if entry),
				:qualification_degree => (entry.DEGREE.to_i if entry),
				:qualification_foundation => (entry.FOUNDATION.to_i if entry),
				:qualification_none => (entry.NOQUALS.to_i if entry),
				:qualification_other => (entry.OTHER.to_i if entry),
				:qualification_other_he => (entry.OTHERHE.to_i if entry),
				
				:nss_teaching => nss_teaching,
				:nss_feedback => nss_feedback,
				:nss_academic => nss_academic,
				:nss_resources => nss_resources,
				:nss_personal_development => nss_personal_development,
				
				:salary_subject_average => salary.try(:LDMED).presence,
				:salary_course_average => salary.try(:INSTMED).presence
			}

			course.save!

		end

	end

end
