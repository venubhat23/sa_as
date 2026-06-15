class CreateGeneralSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :general_settings do |t|
      t.string :key
      t.text :value
      t.text :description

      t.timestamps
    end
  end
end
