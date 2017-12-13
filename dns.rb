#!/usr/bin/env ruby

require 'httparty'

TOKEN = ENV['DIGITALOCEAN_ACCESS_TOKEN'] || ''
DOMAIN = ENV['DOMAIN'] || ARGV[0]
RECORD = ENV['RECORD'] || ARGV[1] || ARGV[0]

class Record
  include HTTParty

  attr_reader :domain, :name

  base_uri 'https://api.digitalocean.com/v2'
  HEADERS = { 'Authorization' => "Bearer #{TOKEN}" }

  def initialize(domain, name)
    @domain = domain
    @name = name
  end

  def all
    response = self.class.get("/domains/#{domain}/records?per_page=200", headers: HEADERS)
    fail_and_exit("Fetching all records failed: #{response.body}") unless response.success?
    response['domain_records']
  end

  def update(ip)
    record = all.detect { |r| r['type'] == 'A' && r['name'] == name }
    if record['data'] == ip
      log("Record already set to #{ip}")
    else
      response = self.class.put("/domains/#{domain}/records/#{record['id']}", query: { data: ip }, headers: HEADERS)
      fail_and_exit("Updating record to #{ip} failed: #{response.body}") unless response.success?
      log("Record set to #{ip}")
    end
  end

  def log(message)
    puts "[#{Time.now}] (#{name}.#{domain}) #{message}"
  end

  def fail_and_exit(message)
    STDERR.puts("[#{Time.now}] (#{name}.#{domain}) #{message}")
    exit false
  end
end

class DoDynDNS
  def self.push_ip(domain, name, ip = fetch_ip)
    record = Record.new(domain, name)
    record.update(ip)
  end

  def self.fetch_ip
    `dig +short @resolver1.opendns.com myip.opendns.com`.strip
  end
end

DoDynDNS.push_ip(DOMAIN, RECORD)
