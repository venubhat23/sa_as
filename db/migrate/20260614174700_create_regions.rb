class CreateRegions < ActiveRecord::Migration[8.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :code
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
