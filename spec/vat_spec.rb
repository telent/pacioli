require 'support/db'
require 'pacioli'


describe "Tax" do
  it "should store a list of vat percentages for different rates and times"
  it "should default to transaction date if no date specified"
  it "should default to standard rate if no rate given"
  it "should create input vat transactions using :assets,:inputvat"
  it "should create output vat tx using :liabilities,:vat"
  it "should calculate quarterly (output - input) liability"
  it "should do the right thing with zero and exempt transactions"
end
