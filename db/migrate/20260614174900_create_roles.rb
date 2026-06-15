class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.string :status, default: "active"
      t.boolean :is_system_role, default: false

      t.timestamps
    end
  end
end
