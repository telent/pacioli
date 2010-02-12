#!/usr/bin/env ruby
class CreateTables < Sequel::Migration
  def up
    create_table :accounts do
      primary_key :id
      foreign_key :parent_id, :accounts
      String :name
      String :label
    end
    self << "insert into accounts (parent_id,name) values(null,'root')"
  end
  def down
    drop_table :accounts
  end
end
