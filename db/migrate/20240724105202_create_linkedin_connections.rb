class CreateLinkedinConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :linkedin_connections do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :position
      t.string :company
      t.string :profile_url
      t.date :connected_on
      t.integer :user_id

      t.timestamps
    end
  end
end
