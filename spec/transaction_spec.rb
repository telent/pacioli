require 'support/db'
require 'pacioli'

describe Transaction do
  it "should exist after creating" do
    tx=Transaction.create
    tx.should respond_to(:date)
  end
  it "should create balanced transaction" do
    ac1=Account.root.make_child :name=>:from
    ac2=Account.root.make_child :name=>:to
    tx=nil
    lambda {
      tx=Transaction.post :description=>"test tx", :date=>Time.now do 
        cr 10,:from
        dr 10,:to
      end
    }.should_not raise_error UnbalancedTransactionError
    tx.description.should == "test tx"
    now=Time.now
    tx.date.should <= now
    tx.date.should > now-30 # something wrong if the creation takes >30 s
  end
  it "should refuse unbalanced transaction" do
    ac1=Account.root.make_child :name=>:from
    ac2=Account.root.make_child :name=>:to
    lambda {
      Transaction.post do 
        cr 110,:from
        dr 10,:to
      end
    }.should raise_error UnbalancedTransactionError
  end
  it "should balance a tx with one unknown" do
    lambda {
      Transaction.post do 
        cr 10,:from
        dr :balance,:to
      end
    }.should_not raise_error UnbalancedTransactionError
  end
end
