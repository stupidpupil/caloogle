Sequel.migration do
  change do
    create_table(:sync_results) do
      primary_key :id
      foreign_key :calendar_id, :calendars
      foreign_key :icalendar_receipt_id, :icalendar_receipts

      String :response_body, :text => true, :null => false
      Time :attempted_at, :null => false
    
    end
  end
end