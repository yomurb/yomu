# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yomu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Erol Fornoles"]
  gem.email         = ["erol.fornoles@gmail.com"]
  gem.description   = %q{Read text and metadata from files and documents (.doc, .docx, .pages, .odt, .rtf, .pdf)}
  gem.summary       = %q{Read text and metadata from files and documents (.doc, .docx, .pages, .odt, .rtf, .pdf)}
  gem.homepage      = "http://erol.github.com/yomu"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "yomu"
  gem.require_paths = ["lib"]
  gem.version       = Yomu::VERSION

  gem.add_runtime_dependency 'mime-types', '~> 1.23'

  gem.add_development_dependency 'rspec'
end
