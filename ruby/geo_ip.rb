#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION =~ /1\.8/

require 'ipaddr'
require 'geokit'
require 'optparse'

# Simple script to make an attempt at geolocating an IP.
class GeoIP

  def self.run!(*args)
    new(*args).run!
  end

  def initialize(argv = ARGV)
    @argv = argv
    @options = {  # defaults
    }

    # Setup the OptionParser and use the remaining args as the IP list.
    setup_option_parser!
    @ip_list = @argv
  end

  # Only public facing method; does the actual work.
  def run!
    begin
      @opt_parser.parse!(@argv)
    rescue OptionParser::InvalidOption => error
      $stderr.puts "#{error}\n#{@opt_parser}"
    rescue OptionParser::MissingArgument => error
      $stderr.puts "#{error}\n#{@opt_parser}"
    end

    # If no IPs given, output usage text.
    if @ip_list.empty?
      @opt_parser.parse!(['--help'])
    end

    @ip_list.each do |ip|
      geolocate(ip)
      output "\n" # spacer
    end
  end

  private

  def geolocate(ip)
    # Ensure that +ip+ is valid.
    begin
      IPAddr.new(ip)
    rescue
      raise "Invalid IP: #{ip}"
    end

    location = Geokit::Geocoders::MultiGeocoder.geocode(ip)

    output('-' * ip.length)
    output(ip)
    output('-' * ip.length)

    output("City: #{location.city}")
    output("State: #{location.state}")
    output("Country: #{location.country_code}")
    output("Address: #{location.full_address}")
  end

  def setup_option_parser!
    @opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename($0)} [options] <ip_list>"
      opts.separator ''
      opts.separator 'Options:'

      opts.on('--debug', 'Set the $DEBUG flag.') do |on_or_off|
        $DEBUG = on_or_off
      end

      opts.on_tail('--help', 'Show this help message.') do
        puts opts
        exit
      end
    end
  end

  def output(message, opts = { :stream => STDOUT, :method => :puts })
    opts[:stream].send(opts[:method], message)
  end

end # GeoIP

GeoIP.run! if $0 == __FILE__
