class Currency
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def self.get(code)
    code
  end

  def eql?(other)
    self == (other)
  end

  def ==(other)
    other.equal?(self) ||
      (other.instance_of?(self.class) &&
       other.code == code)
  end
end

usd = Currency.get("USD")
p usd
p Currency.new("USD") == Currency.new("USD")
p Currency.new("USD").eql?(Currency.new("USD"))
