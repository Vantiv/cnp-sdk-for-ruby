# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'CnpOnline'
  spec.version       = CnpOnline::VERSION
  spec.authors       = ['Ryan Kortmann']
  spec.email         = ['ryan.kortmann@food52.com']
  spec.summary       = 'Food52 Forked version of CnpOnline from Vantiv/WorldPay'
  spec.description   = 'A wrapper for the Vantiv/WorldPay CnpOnline API'
  spec.homepage      = 'https://github.com/food52/cnp-sdk-for-ruby'
  spec.platform      = Gem::Platform::RUBY
  spec.license       = 'MIT'

  spec.files         = Dir['**/**']
  spec.executables   = ['sample_driver.rb', 'Setup.rb']
  spec.test_files    = Dir['test/unit/ts_unit.rb']

  spec.add_dependency('xml-object')
  spec.add_dependency('xml-mapping')
  spec.add_dependency('net-sftp')
  spec.add_dependency('libxml-ruby')
  spec.add_dependency('crack')
  spec.add_dependency('iostreams')
  spec.add_development_dependency('mocha')
end
