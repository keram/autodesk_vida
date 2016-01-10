# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autodesk_vida/version'

Gem::Specification.new do |spec|
  spec.name          = 'autodesk_vida'
  spec.version       = AutodeskVida::VERSION
  spec.authors       = ['Marek Labos']
  spec.email         = ['nospam.keram@gmail.com']

  spec.summary       = 'Autodesk View and Data API wrapper'
  spec.description   = 'Autodesk View and Data API wrapper'
  spec.homepage      = 'https://github.com/keram/autodesk_vida'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  spec.metadata['allowed_push_host'] = 'lorem.ipsum'

  spec.files         = `git ls-files -z`.split("\x0")
                       .reject { |f| f.match(/^(test|\.)/) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'

  # http libraries
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'hurley'
end
