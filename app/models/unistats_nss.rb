class UnistatsNss < ActiveRecord::Base
  establish_connection(:unistats)
  set_table_name :nss
  set_primary_key :recordId
end
