UkCourseMap::Application.routes.draw do

  root :to => "search#index"

  get "jobs/:id/courses.json" => "search#getcoursesfromjob"
  get "jacs/:jacs_code/courses.json" => "search#getcoursesfromjac"
  get "courses.json"          => "search#getcourses"

end
