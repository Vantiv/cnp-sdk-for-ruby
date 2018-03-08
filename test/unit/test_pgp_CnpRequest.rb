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
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
require File.expand_path("../../../lib/CnpOnline",__FILE__)
require 'test/unit'
require 'mocha/setup'
require 'fileutils'

module CnpOnline

  class TestPgpCnpRequest < Test::Unit::TestCase

    def setup
      dir = '/tmp/cnp-sdk-for-ruby-test'
      FileUtils.rm_rf dir
      Dir.mkdir dir

    end

    def test_noPublicKey
      config_dir = ENV['CNP_CONFIG_DIR']
      ENV['CNP_CONFIG_DIR'] = '/tmp/pgp_ruby'
      dir = '/tmp'

      test = ''
      request = CnpRequest.new()
      ENV['CNP_CONFIG_DIR'] = config_dir
      request.create_new_cnp_request(dir + '/cnp-sdk-for-ruby-test')
      request.finish_request
      request.send_to_cnp(dir + '/cnp-sdk-for-ruby-test', {'vantivPublicKeyID' => ''})

    rescue RuntimeError => e
      test = e.message

    clear_outbound
    assert_equal "The public key to encrypt batch file requests is missing from the config", test
    end

    def test_incorrectPublicKey
      config_dir = ENV['CNP_CONFIG_DIR']
      ENV['CNP_CONFIG_DIR'] = '/tmp/pgp_ruby'
      dir = '/tmp'

      test = ''
      request = CnpRequest.new()
      ENV['CNP_CONFIG_DIR'] = config_dir
      request.create_new_cnp_request(dir + '/cnp-sdk-for-ruby-test')
      request.finish_request
      request.send_to_cnp(dir + '/cnp-sdk-for-ruby-test', {'vantivPublicKeyID' => '7E25EB2X'})


    rescue ArgumentError => e
      test = e.message
    clear_outbound
    assert_match(/GPG Failed to create encrypted file:/, test)
    end

    def test_noPassphrase
      config_dir = ENV['CNP_CONFIG_DIR']
      ENV['CNP_CONFIG_DIR'] = '/tmp/pgp_ruby'
      dir = '/tmp'

      test = ''
      request = CnpRequest.new()
      ENV['CNP_CONFIG_DIR'] = config_dir
      request.create_new_cnp_request(dir + '/cnp-sdk-for-ruby-test')
      request.finish_request
      request.send_to_cnp
      request.get_responses_from_server({'passphrase' => ''})

    rescue RuntimeError => e
      test = e.message
    clear_outbound
    assert_equal "The passphrase to decrypt the batch file responses is missing from the config", test

    end

    def test_incorrectPassphrase
      config_dir = ENV['CNP_CONFIG_DIR']
      ENV['CNP_CONFIG_DIR'] = '/tmp/pgp_ruby'
      dir = '/tmp'

      test = ''
      request = CnpRequest.new()
      ENV['CNP_CONFIG_DIR'] = config_dir
      request.create_new_cnp_request(dir + '/cnp-sdk-for-ruby-test')
      request.finish_request
      request.send_to_cnp
      request.get_responses_from_server({'passphrase' => 'gameover:('})

    rescue ArgumentError => e
      test = e.message
    clear_outbound
    assert_match(/GPG Failed to decrypt file:/, test)
    end


    def clear_outbound
      config_dir = ENV['CNP_CONFIG_DIR']
      ENV['CNP_CONFIG_DIR'] = '/tmp/pgp_ruby'
      options = Configuration.new.config
      sftp_username = options['sftp_username']
      sftp_password = options['sftp_password']
      sftp_url = options['sftp_url']
      ENV['CNP_CONFIG_DIR'] = config_dir

      Net::SFTP.start(sftp_url, sftp_username, :password => sftp_password) do |sftp|
        handle = sftp.opendir!('/outbound/')
        files_on_srv = sftp.readdir!(handle)
        files_on_srv.each {|file|
          if (file.name =~ /request_\d+.complete.encrypted.asc\z/) != nil
            sftp.remove('/outbound/' + file.name)
          end
        }
      end
    end

  end
end
