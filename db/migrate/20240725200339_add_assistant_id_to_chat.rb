class AddAssistantIdToChat < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :assistant_id, :string
  end
end
