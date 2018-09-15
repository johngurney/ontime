json.extract! contact, :id, :first_name, :last_name_, :client_id_integer, :telephone_number, :email_address, :position, :priority, :comments, :created_at, :updated_at
json.url contact_url(contact, format: :json)
