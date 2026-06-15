class CreateSidebarAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :sidebar_accesses do |t|
      t.bigint :role_id
      t.string :menu_key
      t.boolean :is_enabled, default: true

      t.timestamps
    end
  end
end
