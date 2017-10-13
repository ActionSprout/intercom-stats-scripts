require './abstract_export'

class ExportUserEvents < AbstractExport
  private

  def fetch_results
    user_ids.each do |user_id|
      puts "Exporting events for #{user_id}.....\n"
      data << get_events(user_id)
    end
  end

  def user_ids
    criteria[:user_ids]
  end

  def get_events(user_id)
    intercom.events.find_all('type' => 'user', 'user_id' => user_id).to_a
  rescue
    return []
  end

  def format_datum(datum)
    [
      datum.user_id,
      datum.email,
      datum.event_name,
      Time.at(datum.created_at),
    ]
  end

  def headers
    ["User ID", "Email", "Event Name", "Created At"]
  end

  def filename_prefix
    'user-events'
  end
end
