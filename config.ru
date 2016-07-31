$:<<'lib'

require 'omniauth'
require 'omniauth-google-oauth2'

require 'sinatra'
require 'caloogle'

class App < Sinatra::Base

  get '/' do
    u =  User.find(uid:session['uid'])
    #redirect to('/auth/google_oauth2') if u.nil?

    if u
      haml 'calendar/index'.to_sym, :locals => {user:u}
    else
      haml :welcome
    end
  end

  get '/calendar/:gcal_id' do
    u =  User.find(uid:session['uid'])
    redirect to('/auth/google_oauth2') if u.nil?

    redirect to('/') if u.google_calendar_with_id(params[:gcal_id])['error']

    c = Calendar.find_or_create(user_id: u.id, gcalendar_id:params[:gcal_id])

    haml 'calendar/show'.to_sym, :locals => {user:u, calendar:c}
  end


  post '/calendar/:gcal_id' do
    u =  User.find(uid:session['uid'])
    redirect to('/auth/google_oauth2') if u.nil?

    redirect to('/') if u.google_calendar_with_id(params[:gcal_id])['error']

    c = Calendar.find_or_create(user_id: u.id, gcalendar_id:params[:gcal_id])

    c.enabled = (params['enabled'])
    c.approved_email_list = ''+params['approved_email_list']
    c.save

    redirect to("/calendar/#{params[:gcal_id]}")
  end

  get '/logout' do
    session['uid'] = nil
    redirect to('/')
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'

    u = User.find_or_create(uid:env['omniauth.auth']['uid'])
    u.refresh_token = env['omniauth.auth']['credentials']['refresh_token']
    u.save

    session[:uid] = env['omniauth.auth']['uid']

    redirect to('/')
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end

use Rack::Session::Cookie, :secret => Caloogle::Config.rack_secret

client_secrets = Google::APIClient::ClientSecrets.load(File.expand_path('../config/client_secrets.json', __FILE__))

use OmniAuth::Builder do
  provider :google_oauth2, client_secrets.client_id, client_secrets.client_secret, {scope:'email,https://www.googleapis.com/auth/calendar'}
end

run App.new