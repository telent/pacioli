#!/usr/bin/env ruby
class CreateTxTable < Sequel::Migration
  def up
    create_table :transactions do
      primary_key :id
      DateTime :date
      String :description
      String :machine_data
    end
  end
  def down
    drop_table :transactions
  end
end
      
    
