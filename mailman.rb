require 'caloogle'

Mailman::Application.run do


  to(/caloogle\+(.+?)@stupidpupil\.co\.uk/)  do

    next if message.attachments.empty?

    attachment = message.attachments.first
    next if File.extname(attachment.filename) != ".ics"

    decoded_attachment = attachment.decoded
    decoded_attachment.force_encoding('UTF-8')

    puts message.from

    IcalendarReceipt.create(to:message.to.first, from:message.from.first, data:decoded_attachment)

  end


end

