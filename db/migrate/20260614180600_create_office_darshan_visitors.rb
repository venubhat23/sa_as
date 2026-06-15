class CreateOfficeDarshanVisitors < ActiveRecord::Migration[8.0]
  def change
    create_table :office_darshan_visitors do |t|
      t.bigint :office_darshan_id
      t.bigint :member_id
      t.string :visitor_type

      t.timestamps
    end
  end
end
