Gem::Specification.new do |s|
  s.name        = 'scli'
  s.version     = '0.0.2'
  s.date        = '2012-06-30'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Josh Pasqualetto']
  s.email       = ['josh.pasqualetto@sonian.net']
  s.homepage    = 'https://github.com/sniperd/scli'
  s.summary     = 'CLI Interface to IBM SmartCloud API'
  s.description = 'A command line tool to interface with IBM SmartCloud: create, view & delete instances, keys, volumes, addresses, etc'
  s.license     = 'MIT'
  s.has_rdoc    = false

  s.add_dependency('fog', '~> 1.3.1')
  s.add_dependency('mixlib-cli', '~> 1.2.2')
  s.add_dependency('terminal-table', '~> 1.4.5')
  s.add_dependency('colored', '1.2')

  s.files         = Dir.glob('{bin,lib}/**/*') + %w[scli.gemspec README.org MIT-LICENSE.txt]
  s.executables   = Dir.glob('bin/**/*').map { |file| File.basename(file) }
  s.require_paths = ['lib']
end
