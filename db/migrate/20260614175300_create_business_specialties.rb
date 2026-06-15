class CreateBusinessSpecialties < ActiveRecord::Migration[8.0]
  def change
    create_table :business_specialties do |t|
      t.string :name
      t.bigint :business_category_id
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
