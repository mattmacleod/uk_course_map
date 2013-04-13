class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title

      t.string :kis_course_id
      t.integer :institution_id
      t.string :jcas_code
      t.string :ucas_code

      t.string :url_course
      t.string :url_financial_support
      t.string :url_employment
      t.string :url_teaching

      t.string :study_mode

      t.boolean :has_means_tested_support
      t.boolean :has_other_support
      
      t.integer :fees_scotland
      t.integer :fees_england
      t.integer :fees_wales
      t.integer :fees_ireland
      
      t.integer :success_first_year_dropout
      t.integer :success_full
      t.integer :success_partial
      t.integer :success_failure
      
      t.integer :outcome_work
      t.integer :outcome_study
      t.integer :outcome_unemployed

      t.integer :qualification_access

      t.integer :qualification_a_level
      t.integer :qualification_bacc
      t.integer :qualification_degree
      t.integer :qualification_foundation
      t.integer :qualification_none
      t.integer :qualification_other
      t.integer :qualification_other_he

      t.integer :nss_teaching
      t.integer :nss_feedback
      t.integer :nss_academic
      t.integer :nss_resources
      t.integer :nss_personal_development

      t.integer :salary_subject_average
      t.integer :salary_course_average
      
      t.timestamps
    end
  end
end
