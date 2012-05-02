# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rprojects/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Imad Manaa"]
  gem.email         = ["imanaa@github.com"]
  gem.homepage      = "https://imanaa@github.com/imanaa/rprojects.git"
  gem.summary       = %q{Useful Ruby Scripts}
  gem.description   = %q{These are a compilation of useful scripts and libraries in Ruby}

  gem.files         = `git ls-files`.split($\)
  gem.bindir        = "bin"
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rprojects"
  gem.require_paths = ["lib"]

  gem.extra_rdoc_files << 'README.md' << 'LICENSE'
  gem.rdoc_options += [
    '--title', 'Rprojects Docs',
    '--main', 'README.rdoc',
    '--dir', 'doc',
    '--exclude', '',
    '--line-numbers'
  ]

  gem.version       = Rprojects::VERSION
end