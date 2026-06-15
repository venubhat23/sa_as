class CreateForums < ActiveRecord::Migration[8.0]
  def change
    create_table :forums do |t|
      t.string :name
      t.text :description
      t.string :code
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
