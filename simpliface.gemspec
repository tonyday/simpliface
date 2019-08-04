# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simpliface/version'

Gem::Specification.new do |spec|
  spec.name = 'simpliface'
  spec.version = Simpliface::VERSION
  spec.authors = ['Tony Day']

  spec.summary = 'Module to add a (very) simple interface to a _Service_'
  spec.homepage = 'https://github.com/tonyday/simpliface'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  end

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
