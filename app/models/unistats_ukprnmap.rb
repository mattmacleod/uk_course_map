class UnistatsUkprnmap < ActiveRecord::Base
  # attr_accessible :title, :body
  establish_connection(:unistats)
  set_table_name :ukprnmap
  set_primary_key :ukprn
end
