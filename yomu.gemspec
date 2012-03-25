# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yomu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Erol Fornoles"]
  gem.email         = ["erol.fornoles@gmail.com"]
  gem.description   = %q{Yomu is a library for extracting text and metadata using the Apache TIKA content analysis toolkit.}
  gem.summary       = %q{Yomu is a library for extracting text and metadata using the Apache TIKA content analysis toolkit.}
  gem.homepage      = "http://github.com/Erol/yomu"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "yomu"
  gem.require_paths = ["lib"]
  gem.version       = Yomu::VERSION
end