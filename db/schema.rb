# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130413120218) do

  create_table "course_jobs", :force => true do |t|
    t.integer  "course_id"
    t.integer  "job_id"
    t.integer  "percentage"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.string   "kis_course_id"
    t.integer  "institution_id"
    t.string   "jcas_code"
    t.string   "ucas_code"
    t.string   "url_course"
    t.string   "url_financial_support"
    t.string   "url_employment"
    t.string   "url_teaching"
    t.string   "study_mode"
    t.boolean  "has_means_tested_support"
    t.boolean  "has_other_support"
    t.integer  "fees_scotland"
    t.integer  "fees_england"
    t.integer  "fees_wales"
    t.integer  "fees_ireland"
    t.integer  "success_first_year_dropout"
    t.integer  "success_full"
    t.integer  "success_partial"
    t.integer  "success_failure"
    t.integer  "outcome_work"
    t.integer  "outcome_study"
    t.integer  "outcome_unemployed"
    t.integer  "qualification_access"
    t.integer  "qualification_a_level"
    t.integer  "qualification_bacc"
    t.integer  "qualification_degree"
    t.integer  "qualification_foundation"
    t.integer  "qualification_none"
    t.integer  "qualification_other"
    t.integer  "qualification_other_he"
    t.integer  "nss_teaching"
    t.integer  "nss_feedback"
    t.integer  "nss_academic"
    t.integer  "nss_resources"
    t.integer  "nss_personal_development"
    t.integer  "salary_subject_average"
    t.integer  "salary_course_average"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "institutions", :force => true do |t|
    t.string   "title"
    t.string   "ukprn"
    t.string   "url_accommodation"
    t.integer  "accommodation_cost"
    t.string   "country"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
