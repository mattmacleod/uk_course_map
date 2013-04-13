class UnistatsEmployment < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :employment
  set_primary_key :recordId
end
