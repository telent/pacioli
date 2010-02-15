# -*- ruby -*-
require 'rake'	
require 'spec/rake/spectask'
require 'sequel'
require 'sequel/extensions/migration'

NAME = 'pacioli'
ENV["PACIOLI_DB"] ||= "sqlite://test.sqlite"
PACIOLI_DB=ENV["PACIOLI_DB"]

task :default => [:spec] do end

task :migrate => [] do
  DB=Sequel.connect(ENV["PACIOLI_DB"])
  Sequel::Migrator.apply(DB,"migrations/")
end

task :unmigrate => [] do
  DB=Sequel.connect(ENV["PACIOLI_DB"])
  Sequel::Migrator.apply(DB,"migrations/",0)
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--format specdoc'
  t.rcov = true
end
