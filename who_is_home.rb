require 'timeout'
require 'socket'

PEOPLE = YAML.load_file("#{Rails.root.to_s}/config/widgets/who_is_home.yml")['who_is_home']['people']

def ping(host)
  begin
    Timeout.timeout(5) do 
      s = TCPSocket.new(host, 'echo')
      s.close
      return true
    end
  rescue Errno::ECONNREFUSED
    return true
  rescue
    return false
  end
end

$widget_scheduler.every '30s', first_in: '5s' do
  data = { people: [] }

  PEOPLE.each do |person|
    data[:people] << {
      gravatar_hash: Digest::MD5.new.update(person['email']).to_s,
      name: person['name'],
      status_icon: ping(person['smartphone_hostname']) ? 'check' : 'times'
    }
  end

  WidgetDatum.new(name: 'who_is_home', data: data).save
end
