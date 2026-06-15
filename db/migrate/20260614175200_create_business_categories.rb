class CreateBusinessCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :business_categories do |t|
      t.string :name
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
