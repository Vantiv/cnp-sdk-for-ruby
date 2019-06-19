#!/usr/bin/env ruby

=begin
Copyright (c) 2017 Vantiv eCommerce

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end

# make setup file executable

require 'iostreams'

#
# Configuration generation for URL and credentials
#
class Setup
  attr_reader :handle, :path
  def initialize(filename)
    @handle = File.new(filename, File::CREAT|File::TRUNC|File::RDWR, 0600)
    File.open(filename, 'w') do |f|
      puts 'Welcome to Vantiv eCommerce Ruby_SDK'
      puts 'Please input your user name:'
      f.puts  'user: '+ gets
      puts 'Please input your password:'
      f.puts 'password: ' + gets
      puts 'Please input your merchantId:'
      f.puts 'currency_merchant_map:'
      f.puts '  DEFAULT: ' + gets
      f.puts "default_report_group: 'Default Report Group'"
      puts "Please choose Vantiv eCommerce url from the following list (example: 'prelive') or directly input another URL:
sandbox => hhttps://www.testvantivcnp.com/sandbox/new/sandbox/communicator/online
prelive => https://payments.vantivprelive.com/vap/communicator/online
postlive => https://payments.vantivpostlive.com/vap/communicator/online
production => https://payments.vantivcnp.com/vap/communicator/online
transact_prelive => https://transact.vantivprelive.com/vap/communicator/online
transact_postlive => https://transact.vantivpostlive.com/vap/communicator/online
transact_production => https://transact.vantivcnp.com/vap/communicator/online"
      f.puts 'url: ' + Setup.choice(gets)
      puts 'Please input the proxy address, if no proxy hit enter key: '
      f.puts 'proxy_addr: ' + gets
      puts 'Please input the proxy port, if no proxy hit enter key: '
      f.puts 'proxy_port: ' + gets
      puts 'Please input your sFTP username for batch processing; if no sFTP, hit enter key: '
      f.puts 'sftp_username: ' + gets
      puts 'Please input your sFTP password for batch processing; if no sFTP, hit enter key: '
      f.puts 'sftp_password: ' + gets
      puts 'Please input your sFTP url for batch processing; if no sFTP, hit enter key: '
      f.puts 'sftp_url: ' + gets
      puts 'Please input your url for fast batch processing; if no fast batch, hit enter key: '
      f.puts 'fast_url: ' + gets
      puts 'Please input your port for fast batch processing; if no fast batch, hit enter key: '
      f.puts 'fast_port: ' + gets
      f.puts 'printxml: false'
      # default http timeout set to 500 ms
      f.puts 'timeout: 500'

      puts 'Delete batch files after sending request/processing response (true/false) (false by default): '
      deleteBatchFiles = (gets.chomp() == 'true')
      f.puts "deleteBatchFiles: #{deleteBatchFiles}"
      puts 'Use PGP encryption for sending batch files through sftp (true/false) (No encryption by default): '
      useEncryption = (gets.chomp() == 'true')
      f.puts "useEncryption: #{useEncryption}"
      if useEncryption
        puts "Path to Vantiv's Public key (For encryption of batch files): "
        puts "Note: The key from the provided file path will be added to your gpg keyring. If you do not have gpg2 installed, please install it before proceeding"
        key_path = gets.chomp()
        key = File.read(key_path)
        key_info = IOStreams::Pgp.import(key: key)
        if key_info.empty?
          key_info = IOStreams::Pgp.key_info(key: key)
        end
        key_id = key_info[0][:key_id]
        f.puts "vantivPublicKeyID: " + key_id
        puts "Enter passphrase of your merchant key for decrypting responses: "
        f.puts "passphrase: " + gets.chomp()
      end
    end
  end

  def finished
    @handle.close
  end

  def Setup.choice(cnp_env)
    cnp_online_ctx = 'vap/communicator/online'
    if cnp_env == "sandbox\n"
      return 'https://www.testvantivcnp.com/sandbox/communicator/online'
    elsif cnp_env == "prelive\n"
      return 'https://payments.vantivprelive.com/' + cnp_online_ctx
    elsif cnp_env == "postlive\n"
      return 'https://payments.vantivpostlive.com/' + cnp_online_ctx
    elsif cnp_env == "production\n"
      return 'https://payments.vantivcnp.com/' + cnp_online_ctx
    elsif cnp_env == "transact_production\n"
      return 'https://transact.vantivcnp.com/' + cnp_online_ctx
    elsif cnp_env == "transact_prelive\n"
      return 'https://transact.vantivprelive.com/' + cnp_online_ctx
    elsif cnp_env == "transact_postlive\n"
      return 'https://transact.vantivpostlive.com/' + cnp_online_ctx
    else
      return 'https://www.testvantivcnp.com/sandbox/communicator/online'
    end
  end
end

#
#
# Optionally enable the configuration to reside in a custom location
# if the $CNP_CONFIG_DIR directory is set
#

# make the config.yml file in the CNP_CONFIG_DIR directory or HOME directory
if !(ENV['CNP_CONFIG_DIR'].nil?)
  path = ENV['CNP_CONFIG_DIR']
else
  path = ENV['HOME']
end

# make the config.yml file hidden
# create a config file contain all the configuration data
config_file = path + '/.cnp_SDK_config.yml'
f = Setup.new(config_file)

# return the path of the config file and the path file
@path = File.expand_path(config_file)
puts 'The Vantiv eCommerce configuration file has been generated, the file is located at: ' + @path
f.finished

