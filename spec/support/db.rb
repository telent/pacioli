require 'sequel'
require 'sequel/extensions/migration'
require 'logger'

File.delete "test.sqlite" if File.exists? "test.sqlite"
DB=Sequel.connect(ENV["PACIOLI_DB"])
Sequel::Migrator.apply(DB,"migrations/")

#DB.loggers << Logger.new($stdout)
