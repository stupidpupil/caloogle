class IcalendarReceipt < Sequel::Model

  many_to_one :calendar
  one_to_many :sync_results

  def icalendar
    @icalendar ||= Icalendar.parse self.data
  end

  def sync!
    calendar.synchronise_with_icalendar_receipt self
  end

  def set_calendar!
    if self.to and self.from
      tag = self.to.match(/.+?\+(.+?)@/)[1]
      c = Calendar.find(tag:tag)
      self.calendar = c if c.approved_emails.include? self.from.downcase
    end
  end

  def before_create
    self.received_at ||= Time.now
    set_calendar!
    super
  end

end