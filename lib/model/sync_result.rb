class SyncResult < Sequel::Model

  many_to_one :calendar
  many_to_one :icalendar_receipt

end