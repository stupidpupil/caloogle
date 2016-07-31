Sequel.migration do
  change do
    create_table(:icalendar_receipts) do
      primary_key :id
      foreign_key :calendar_id, :calendars
      
      String :data, :text => true, :null => false
      
      String :to, :null => false
      String :from, :null => false
      
      Time :received_at, :null => false
    end
  end
end