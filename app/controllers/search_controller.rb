class SearchController < ApplicationController

	def index
	end

	def example
		render :json => Job.find(49).courses.order("percentage DESC").to_json
	end
	
end
