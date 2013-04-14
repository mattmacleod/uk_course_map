class SearchController < ApplicationController

    def index
    end

    def level1
    	output = {}
    	
    	jobs = Job.all
    	categories = JacsCode.categories
    	
    	output[:categories] = categories.map {|c| {:category => c, :weights => c.job_weights } }
		output[:jobs] = jobs

    	render :json => output
    end

    def all_data

    	output = { :size => (10000..30000).to_a.sample }
    	categories = JacsCode.categories
        output[:categories] = []
    	
        categories.each do |category|
    		output[:categories] << {
    			:name => category.title,
    			:size => (10000..30000).to_a.sample,
    			:sub_categories => category.children.map{ |child| 
    				{
    					:name => child.title,
    					:size => (10000..30000).to_a.sample
    				}
    			}
    		}
    	end

    	render :json => output
        
    end

    def jobs
        render :json => Job.all.to_json(:only => [:title, :id])
    end

end
