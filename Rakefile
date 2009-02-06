require 'rake'
require 'rubygems'
require 'rake/rdoctask'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = "activerecord-comments"
    s.summary     = "Provides an easy to access database table/column comments from ActiveRecord"
    s.email       = "remi@remitaylor.com"
    s.homepage    = "http://github.com/openrain/activerecord-comments"
    s.description = "Provides an easy to access database table/column comments from ActiveRecord"
    s.authors     = %w( remi )
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'activerecord-comments'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Confirm that gemspec is $SAFE'
task :safe do
  require 'yaml'
  require 'rubygems/specification'
  data = File.read('activerecord-comments.gemspec')
  spec = nil
  if data !~ %r{!ruby/object:Gem::Specification}
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
  else
    spec = YAML.load(data)
  end
  spec.validate
  puts spec
  puts "OK"
end

task :default => :spec
