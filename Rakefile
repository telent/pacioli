# -*- ruby -*-
require 'rake'	
require 'spec/rake/spectask'

NAME = 'pacioli'
ENV["PACIOLI_DB"] ||= "sqlite://test.sqlite"
PACIOLI_DB=ENV["PACIOLI_DB"]

task :default => [:spec] do end

task :migrate => [] do
  # this is a somewhat tacky way to run migrations, but it'll do
  puts `sequel -m migrations/ #{PACIOLI_DB}`
end

task :unmigrate => [] do
  puts `sequel -M 0  -m migrations/ #{PACIOLI_DB}`
end

task :spec => [:migrate,:run_spec]

Spec::Rake::SpecTask.new(:run_spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--format specdoc'
  t.rcov = true
end
