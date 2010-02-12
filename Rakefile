# -*- ruby -*-
require 'rake'	
require 'pp'


task :default => [:test] do end

task :migrate => [] do
  puts `sequel -m migrations/ postgres://dan:dan@localhost/dan`
end
task :unmig => [] do
  puts `sequel -M 0  -m migrations/ postgres://dan:dan@localhost/dan`
end

task :spec => [:migrate] do
  puts `spec account_spec.rb transaction_spec.rb`
end


