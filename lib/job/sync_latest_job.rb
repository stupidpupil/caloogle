class SyncLatestJob < Que::Job

  def self.enqueue_unless_exists(calendar_id, *args)
    return unless DB[:que_jobs].where(job_class:self.to_s).where('args->>0 = ?', calendar_id.to_s).none?
    self.enqueue calendar_id, *args
  end

  def run(calendar_id)
    DB.disconnect

    c = Calendar[calendar_id]
    destroy and return if c.nil?

    latest_icalendar_receipt = c.icalendar_receipts_dataset.order(:received_at).last

    destroy and return if !c.enabled

    c.synchronise_with_icalendar_receipt latest_icalendar_receipt

    Pony.mail(
      to: latest_icalendar_receipt.from,
      subject: 'Calendar updated!',
      body: 'Calendar updated!'
      )
  end

end