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
  		#children.map { |c| c.weight_to( job ) }._average
  	else

  		# Setup course variables
  		courses_length = courses.count
  		job_weights = {}

  		# Extract the job weights from every course
  		courses.map(&:job_weights).flatten.each do |jobweight|
  			job    = jobweight.keys.first
  			weight = jobweight.values.first

  			job_weights[ job ] ||= []
  			job_weights[ job ] << weight
  		end

  		# Averaging the weights over all courses
  		averages = {}
  		job_weights.each do |job,weights|
  			padding_zeros = courses_length - weights.length
  			averages[ job ] = (weights + [0]*padding_zeros)._average
  		end

  		return averages

  	end
  end

end
