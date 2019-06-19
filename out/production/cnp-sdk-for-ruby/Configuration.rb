# Copyright (c) 2017 Vantiv eCommerce
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

require 'yaml'
require_relative 'EnvironmentVariables'

#
# Loads the configuration from a file
#
module CnpOnline
  class Configuration
    class << self
      # External logger, if specified
      attr_accessor :logger
    end

    def config
      if !ENV['CNP_CONFIG_DIR'].nil?
        config_file = ENV['CNP_CONFIG_DIR'] + '/.cnp_SDK_config.yml'
      else
        config_file = ENV['HOME'] + '/.cnp_SDK_config.yml'
      end

      datas = {}
      # if Env variable exist, then just override the data from config file
      if File.exist?(config_file)
        datas = YAML.load_file(config_file)
      end

      environments = EnvironmentVariables.new
      environments.instance_variables.each do |var|
        if datas[var.to_s.delete('@')].nil?
          datas[var.to_s.delete('@')] = environments.instance_variable_get(var)
        end
      end
      datas.each { |key, _value| setENV(key, datas) }
      return datas
    rescue
      return {}
    end

    def setENV(key, datas)
      val = ENV['cnp_' + key]
      if !val.nil?
        if val == 'true'
          datas[key] = true
        elsif val == 'false'
          datas[key] = false
        else
          datas[key] = val
        end
      end
    end
  end
end
