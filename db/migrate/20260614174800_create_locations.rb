class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.string :pincode
      t.bigint :region_id
      t.bigint :chapter_id

      t.timestamps
    end
  end
end
