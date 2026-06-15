class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.bigint :role_id
      t.string :module_name
      t.boolean :can_view, default: false
      t.boolean :can_create, default: false
      t.boolean :can_edit, default: false
      t.boolean :can_delete, default: false
      t.boolean :can_export, default: false

      t.timestamps
    end
  end
end
