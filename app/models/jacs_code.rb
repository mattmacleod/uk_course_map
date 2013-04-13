class JacsCode < ActiveRecord::Base

  has_and_belongs_to_many :courses
  belongs_to :parent, :class_name => "JacsCode", :foreign_key => :parent_id
  has_many :children, :class_name => "JacsCode", :foreign_key => :parent_id

  class << self
  	def categories
  		self.where(:parent_id => 0)
  	end
  end

  def is_category?
  	parent_id==0
  end

  def job_weights

  	if is_category?
  		valid_children = children.map(&:job_weights).reject(&:blank?).reject{ |j| j.values.sum == 0}
  		average_job_weight_hash valid_children, valid_children.count
  	else
		average_job_weight_hash courses.map(&:job_weights), courses.count
  	end

  end

  private

  def average_job_weight_hash( job_hash, total_length )

	# Get the total weight for each job
	total_weights = {}
	job_hash.each do |job_weights|
		job_weights.each do |job, weight|
			total_weights[job] ||= []
			total_weights[job] << weight
		end
	end

	# Pad to total number of jobs
	padded_weights = {}
	total_weights.each do |job, weights|
		padded_weights[job] = total_weights[job].fill( 0, total_weights[job].length, (total_length-total_weights[job].length) )
	end

	# Calculate average of all jobs!
	average_weights = {}
	padded_weights.each do |job, weights|
		average_weights[job] = weights._average
	end

	average_weights

  end

end
