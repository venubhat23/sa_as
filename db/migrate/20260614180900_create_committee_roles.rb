class CreateCommitteeRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :committee_roles do |t|
      t.string :name
      t.text :description
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
