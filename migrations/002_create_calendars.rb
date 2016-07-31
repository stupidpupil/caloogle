Sequel.migration do
  change do
    create_table(:calendars) do
      primary_key :id
      foreign_key :user_id, :users
      String :gcalendar_id, :null => false

      Boolean :enabled, :default => false
      String :tag, :null => false, :index => {unique:true}
      String :approved_email_list, :default => ''
      
    end
  end
end