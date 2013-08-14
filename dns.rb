require 'rest-client'
require 'json'

CLIENT_ID = ''
API_KEY = ''
DOMAIN = ARGV[0] || ''
RECORD = ARGV[1] || ''

API_URL = 'https://api.digitalocean.com'
API_CREDENTIALS = "client_id=#{CLIENT_ID}&api_key=#{API_KEY}"

def ip
  @ip ||= `dig +short @resolver1.opendns.com myip.opendns.com`.strip
end

def domain
  return @domain if @domain
  log 'Fetching domain'
  response = JSON.parse RestClient.get("#{API_URL}/domains?#{API_CREDENTIALS}")
  response['domains'].each do |domain|
    break domain if domain['name'] == DOMAIN
  end
end

def record
  return @record if @record
  log 'Fetching record'
  response = JSON.parse RestClient.get("#{API_URL}/domains/#{domain['id']}/records?#{API_CREDENTIALS}")
  @record = response['records'].each do |record|
    break record if record['name'] == RECORD
  end
end

def push_ip
  log "Set record to #{ip}"
  response = JSON.parse RestClient.get("#{API_URL}/domains/#{domain['id']}/records/#{record['id']}/edit?#{API_CREDENTIALS}&data=#{ip}")
  log "Record set to #{ip}" if response['status'] == 'OK'
end

def set_ip
  if record['data'] == ip
    log "Record already set to #{ip}"
  else
    push_ip
  end
end

def log message
  puts "[#{Time.now}] #{message}"
end

set_ip
