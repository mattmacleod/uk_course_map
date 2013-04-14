UkCourseMap::Application.routes.draw do

  root :to                  => "search#index"

  get "courses.json"        => "search#getcourses"
  get "level1"              => "search#level1"

  get "all_data.json"       => "search#all_data"
  get "jobs.json"           => "search#jobs"
  get "filter_results.json" => "search#filter_results"

  get "detail" => "search#detail"
  
end
