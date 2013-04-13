class SearchController < ApplicationController

    def index
    end

    def getcoursesfromjob
        render :json => Job.find(params[:id]).courses.order("percentage DESC").to_json
    end

    def getcoursesfromjac
        jacs = JacsCode.where(:jacs_code => params[:jacs_code].to_s.upcase).first

        courses = []
        courses = jacs.courses if jacs.respond_to? :courses
        render :json => courses.to_json
    end

    def getcourses
        render :json => Course.paginate(:page => params[:page])
    end


end
