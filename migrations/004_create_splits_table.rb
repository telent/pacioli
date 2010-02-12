#!/usr/bin/env ruby
class CreateSplitsTable < Sequel::Migration
  def up
    create_table :splits do
      primary_key :id
      foreign_key :account_id,:accounts
      foreign_key :tx_id,:transactions
      Integer :value
    end
  end
  def down
    drop_table :splits
  end
end
