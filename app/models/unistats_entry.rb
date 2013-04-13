class UnistatsEntry < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :entry
  set_primary_key :recordId
end
