UkCourseMap::Application.routes.draw do

  root :to => "search#index"

  get "sample.json" => "search#example"
  
end
