require 'sequel'
require 'pp'

class Account  <Sequel::Model
  def self.root
    Account.filter(:parent_id=>nil).first
  end
  def name
    x=super
    /^[0-9]+$/ =~ x ? x.to_i : x.to_sym
  end
  def children
    Account.filter(:parent_id=>self.id).all
  end
  def find(names)
    kidname=names.shift
    kid=self.children.find { |x| kidname==x.name }
    if names.empty? then kid else kid.find(names) end
  end
    
  # XXX how do we make the #new method private?
  def make_child(args)
    Account.create(args.merge! Hash[:parent_id => self.id ])
  end
  def balance 
    (Split.filter(:account_id=>self.id).sum(:value).to_i or 0) +
      self.children.inject(0) { |s,c| s+=c.balance }
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
  def self.post(*args,&blok)
    tx=Transaction.new(*args)
    tx.instance_eval(&blok)
    uk=tx.find_unknown
    if uk then
      uk[0]=-tx.balance
    end
    raise UnbalancedTransactionError unless tx.balance==0
    tx.write_splits_and_save
    # returns tx
  end
  def write_splits_and_save
    self.db.transaction do
      @splits.each do |split|
        value = split[0]
        account = Account.root.find(split[1])
        Split.create :account_id=>account[:id], :value=> value
      end
      self.save
    end
  end

  def dr(v,*ac)
    @splits << [v, ac]
  end
  def cr(v,*ac)
    @splits << [(v==:balance) ? v : -v, ac]
  end
  def find_unknown
    @splits.find {|s| (s[0]==:balance) }
  end
  def balance
    @splits.select {|s| s[0].is_a?(Integer) }.inject(0) {|sum,split|
      sum+=split[0]
    }
  end
end
