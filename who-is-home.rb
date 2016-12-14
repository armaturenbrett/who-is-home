require 'timeout'
require 'socket'

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

  $config['who-is-home']['people'].each do |person|
    data[:people] << {
      gravatar_hash: Digest::MD5.new.update(person['email']).to_s,
      name: person['name'],
      status_icon: ping(person['smartphone_hostname']) ? 'check' : 'times'
    }
  end

  WidgetDatum.new(name: 'who-is-home', data: data).save
end
