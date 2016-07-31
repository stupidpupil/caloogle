require 'caloogle/config'

require 'i2gcal'

require 'mailman'
require 'pony'
require 'sequel'
require 'que'

Sequel.extension :migration

DB = Sequel.connect(Caloogle::Config.db) unless defined?(DB)
Que.connection = DB
Sequel::Migrator.run(DB, File.expand_path('../../migrations', __FILE__), :use_transactions=>true)


require 'model/user'
require 'model/calendar'
require 'model/icalendar_receipt'
require 'model/sync_result'

require 'job/sync_latest_job'
require 'job/get_email_job'


Mailman.config.pop3 = {
  :username => Caloogle::Config.mail.username,
  :password => Caloogle::Config.mail.password,
  :server   => 'mail.gandi.net',
  :port     => 995, # defaults to 110
  :ssl      => true # defaults to false
}

Pony.options = {
  :from         => 'caloogle@stupidpupil.co.uk',
  :via          => :smtp,
  :via_options  => {
    :address              => 'mail.gandi.net',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => Caloogle::Config.mail.username,
    :password             => Caloogle::Config.mail.password,
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
  }
}

Mailman.config.poll_interval = 0