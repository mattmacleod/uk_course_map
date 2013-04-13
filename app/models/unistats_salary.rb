class UnistatsSalary < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :salary
  set_primary_key :recordId
end
