class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.bigint :user_id
      t.string :title
      t.text :body
      t.string :notification_type
      t.boolean :is_read, default: false
      t.datetime :sent_at

      t.timestamps
    end
  end
end
