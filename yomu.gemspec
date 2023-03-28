# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yomu/version'

Gem::Specification.new do |spec|
  spec.name          = 'yomu'
  spec.version       = Yomu::VERSION
  spec.authors       = ['Erol Fornoles']
  spec.email         = ['erol.fornoles@gmail.com']
  spec.description   = %q{Read text and metadata from files and documents (.doc, .docx, .pages, .odt, .rtf, .pdf)}
  spec.summary       = %q{Read text and metadata from files and documents (.doc, .docx, .pages, .odt, .rtf, .pdf)}
  spec.homepage      = 'http://erol.github.com/yomu'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mime-types', '~> 3.4.1'
  spec.add_runtime_dependency 'json', '~> 2.6'

  spec.add_development_dependency 'bundler', '~> 2.4.10'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.12.0'

  spec.required_ruby_version = '>= 2.7.3'
end
