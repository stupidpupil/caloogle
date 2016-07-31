class User < Sequel::Model

  one_to_many :calendars

  def build_client
    APIClientBuilder.new_client_with_refresh_token(refresh_token)
  end

  def build_synchrograph
    Synchrograph.new(build_client)
  end

  def google_calendars
    c = build_client
    gcal_api = c.discovered_api('calendar', 'v3')
    c.execute(api_method:gcal_api.calendar_list.list, parameters:{'minAccessRole' => 'writer'}).data.items
  end

  def google_calendar_with_id(gcal_id)
    c = build_client
    gcal_api = c.discovered_api('calendar', 'v3')
    c.execute(api_method:gcal_api.calendar_list.get, parameters: {'calendarId' => gcal_id}).data
  end

end