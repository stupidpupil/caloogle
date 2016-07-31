class GetEmailJob < Que::Job
  def self.enqueue_unless_exists(*args)
    DB[:que_jobs].where(job_class:self.to_s).any? or self.enqueue *args
  end

  def run
    DB.disconnect

    Mailman::Application.run do


      to(/caloogle\+(.+?)@stupidpupil\.co\.uk/)  do

        next if message.attachments.empty?

        attachment = message.attachments.first
        next if File.extname(attachment.filename) != ".ics"

        decoded_attachment = attachment.decoded
        decoded_attachment.force_encoding('UTF-8')

        icr = IcalendarReceipt.create(to:message.to.first, from:message.from.first, data:decoded_attachment)

        SyncLatestJob.enqueue_unless_exists icr.calendar.id if icr.calendar

      end


    end


    if DB[:que_jobs].where(:job_class => self.class.to_s).count == 1
      GetEmailJob.enqueue run_at:(Time.now + 10)
    end
  end

  GetEmailJob.enqueue_unless_exists
end