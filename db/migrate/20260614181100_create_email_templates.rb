class CreateEmailTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :email_templates do |t|
      t.string :name
      t.string :subject
      t.text :body
      t.string :template_type
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
