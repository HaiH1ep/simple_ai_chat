json.extract! linkedin_connection, :id, :first_name, :last_name, :email, :position, :company, :profile_url, :connected_on, :created_at, :updated_at
json.url linkedin_connection_url(linkedin_connection, format: :json)
