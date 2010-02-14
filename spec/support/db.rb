require 'sequel'
require 'logger'

DB=Sequel.connect(ENV["PACIOLI_DB"])
#DB.loggers << Logger.new($stdout)
