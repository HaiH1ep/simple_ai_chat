class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :user_id
      t.string :access_key
      t.string :status
      t.timestamps
    end
  end
end
