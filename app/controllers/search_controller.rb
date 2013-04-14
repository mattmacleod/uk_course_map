class SearchController < ApplicationController

    Gradients = [
        ["193,39,45", "237,28,36"],
        ["255,0,255", "46,49,146"],
        ["46,49,146", "255,0,255"],
        ["237,30,121", "158,0,93"],
        ["0,146,69", "57,181,74"],
        ["0,104,55", "0,169,157"],
        ["241,90,36", "193,39,45"],
        ["96,59,19", "96,59,19"],
        ["0,113,188", "41,171,226"],
        ["57,181,74", "0,146,69"],
        ["249,125,255", "248,185,255"],
        ["27,20,100", "46,49,146"],
        ["153,134,117", "115,99,87"],
        ["41,171,226", "0,113,188"],
        ["102,45,145", "147,39,143"],
        ["217,224,33", "252,238,33"],
        ["115,99,87", "153,134,117"],
        ["140,98,57", "198,156,109"],
        ["212,20,90", "237,30,121"]
    ]

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
                :id => category.id,
    			:name => category.title,
    			:size => (10000..30000).to_a.sample,
    			:sub_categories => category.children.map{ |child|
    				{
                        :id => child.id,
    					:name => child.title,
    					:size => (10000..30000).to_a.sample
    				}
    			}
    		}
    	end

    	render :json => output

    end

    def jobs
        if params[:course]
            job = Course.find(params[:course]).jobs
            render :json => job.to_json(:only => [:id, :percent])
        else
            render :json => Job.all.to_json(:only => [:title, :id])
        end
    end

    def getcourses
        if params[:job]
            result = []

            cjobs = Job.find(params[:job]).course_jobs
            cjobs.each do |j|
                if j[:course_id] && j[:course_id] > 0
                    jacs = Course.find(j[:course_id]).jacs_codes.find {|jac| jac[:parent_id] > 0}
                    if jacs
                        result.push({
                            :target    => jacs[:id],
                            #:jacs_code => jacs[:jacs_code],
                            :percent   => j[:percentage]
                        })
                    end
                end
            end

            render :json => result.to_json
        else
            render :json => Course.all.to_json
        end
    end

    # Simple search. Returns a lit of object IDs to be excluded from the graph.
    def filter_results

        # first, get all objects.
        all_jobs = Job.select(:id).all.map(&:id)
        all_categories = JacsCode.categories.select(:id).all.map(&:id)
        all_sub_categories = JacsCode.select(:id).all.map(&:id) - all_categories
        all_courses = Course.select(:id).all.map(&:id)

        # Find matching items
        matching_jobs = Job.tagged_with( params[:job_tags] ).map(&:id)

        matching_courses = Course.scoped
        # if params[]
        # end


        render :json => {

        }

    end

end
