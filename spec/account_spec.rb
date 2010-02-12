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
    ac.name.should == 'test'
  end
  it "should increase balance when debited" do
    ac=Account.root.make_child :name=>:test
    split=Split.create :account_id=>ac.id, :value=>10
    split=Split.create :account_id=>ac.id, :value=>12
    ac.balance.should == 22
  end
  it "should be affected by posted transactions" do
    ac1=Account.root.make_child :name=>:from
    ac2=Account.root.make_child :name=>:to
    Transaction.post do 
      cr 10,:from
      dr 10,:to
    end
    ac1.balance.should == 10
  end

end


