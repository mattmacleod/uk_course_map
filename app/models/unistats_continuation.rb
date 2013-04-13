class UnistatsContinuation < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :continuation
  set_primary_key :recordId
end
