class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :ukprn
      t.string :url_accommodation
      t.integer :accommodation_cost
      t.string :country
      t.timestamps
    end
  end
end
