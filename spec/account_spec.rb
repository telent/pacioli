require 'support/db'
require 'pacioli'

describe Account do
  it "should find root account" do
    Account.root.should respond_to(:balance)
  end
  it "should have a zero balance at creation" do
    ac=Account.root.make_child :name=>:test
    ac.balance.should == 0
  end
  it "should be named when a name is given" do
    ac=Account.root.make_child :name=>:test
    ac.name.should == :test
  end
  it "should allow a number as name" do
    ac=Account.root.make_child :name=>42
    ac.name.should == 42
  end
  it "should be findable by path" do
    ac=Account.root.make_child :name=>:parent
    ac1=ac.make_child :name=>81
    ac2=ac1.make_child :name=>:hello
    Account.root.find([:parent,81,:hello]).should == ac2
  end
  it "should increase balance when debited" do
    ac=Account.root.make_child :name=>:test
    split=Split.create :account_id=>ac.id, :value=>10
    split=Split.create :account_id=>ac.id, :value=>12
    ac.balance.should == 22
  end
  it "should be affected by posted transactions" do
    post=Account.root.make_child :name=>:post
    ac1=post.make_child :name=>:from
    ac2=post.make_child :name=>:to
    Transaction.post do 
      cr 10,:post,:from
      dr 10,:post,:to
    end
    ac1.balance.should == -10
  end
  it "should sum the balances of its sub-accounts" do
    parent=Account.root.make_child :name=>:subaccounts
    dr=Account.root.make_child :name=>:dr
    4.times.each do |n|
      parent.make_child :name=>n 
      Transaction.post do
        cr 10,:subaccounts,n
        dr 10,:dr
      end
    end
    parent.balance.should == -40
  end
end

# chart of accounts - what's the spec?
# year-end: balance sheet should balance
# vat transaction: test the amounts add up
# vat framework: standard/reduced/exempt/outside scope. + rate changes

