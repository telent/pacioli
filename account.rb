require 'sequel'
DB=Sequel.postgres

class Account  <Sequel::Model
  def self.root
    Account.filter(:parent_id=>nil).first
  end
  # XXX how do we make the #new method private?
  def make_child(args)
    Account.create(args.merge! Hash[:parent_id => self.id ])
  end
  def balance 
    (Split.filter(:account_id=>self.id).sum(:value) or 0)
  end
end

class Split < Sequel::Model ;end
class UnbalancedTransactionError < Exception; end

class Transaction < Sequel::Model   
  attr_reader :splits
  def initialize (*args)
    super
    @splits=[]
  end
  def self.post(&blok)
    tx=Transaction.new
    tx.instance_eval(&blok)
    uk=tx.find_unknown
    if uk then
      uk[1]=tx.balance
    end
    raise UnbalancedTransactionError unless tx.balance==0
  end
  def cr(v,*ac)
    @splits << [:c,v, ac]
  end
  def dr(v,*ac)
    @splits << [:d,v, ac]
  end
  def find_unknown
    @splits.find {|s| (s[1]==:balance) }
  end
  def balance
    @splits.select {|s| s[1].is_a?(Integer) }.inject(0) {|sum,split|
      sum+=(split[0]==:c) ? split[1] : -split[1]
    }
  end
end

