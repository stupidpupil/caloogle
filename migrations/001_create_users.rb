Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :uid, :null => false

      String :refresh_token
      Time :refresh_token_expires
    end
  end

end