class CreateChapters < ActiveRecord::Migration[8.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :code
      t.bigint :forum_id
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
