class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :user_id
      t.integer :role
      t.string :content
      t.json :response
      t.integer :response_number, null: false, default: 0

      t.timestamps
    end
  end
end
