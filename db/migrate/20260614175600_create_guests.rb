class CreateGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :guests do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :company_name
      t.bigint :business_category_id
      t.bigint :invited_by_member_id
      t.bigint :chapter_id
      t.integer :lifecycle_status, default: 0
      t.date :visit_date
      t.text :notes
      t.datetime :converted_at
      t.bigint :converted_member_id

      t.timestamps
    end
  end
end
