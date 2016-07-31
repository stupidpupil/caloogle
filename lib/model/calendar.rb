require 'haikunator'

class Calendar < Sequel::Model

  many_to_one :user
  one_to_many :icalendar_receipts
  one_to_many :sync_results

  def synchronise_with_icalendar_receipt(ics_rcpt)
    sr = SyncResult.create(calendar:self, icalendar_receipt:ics_rcpt, response_body:'', attempted_at:Time.now)

    gcal = GCalendar.new(user.build_client, gcalendar_id)
    sr.response_body = user.build_synchrograph.synchronise(gcal, ics_rcpt.icalendar)
    sr.save
  end

  def google_calendar
    @google_calendar ||= user.google_calendar_with_id gcalendar_id
  end

  def approved_emails
    approved_email_list.split(',').map {|e| e.strip.downcase}
  end

  def before_create
    self.tag = Haikunator.haikunate(9999, '.')
    super
  end

  def email_address
    "caloogle+#{tag}@stupidpupil.co.uk"
  end

end