class Item
  attr_accessor :base_price, :tax_rate

  def initialize(base_price, tax_rate)
    setup(base_price, tax_rate)
  end

  def setup(base_price, tax_rate)
    @base_price = base_price
    @tax_rate   = tax_rate
  end

  def raise_base_price_by(percent)
    self.base_price = base_price * (1 + percent/100.0)
  end

  def total
    base_price * (1+ tax_rate)
  end
end

class ImportedItem < Item
  attr_reader :import_duty

  def initialize(base_price, tax_rate, import_duty)
    super(base_price, tax_rate)
    @import_duty = import_duty
  end

  def tax_rate
    super + import_duty
  end
end

i = Item.new(100, 0.05)
puts i.total
i.raise_base_price_by(0.05)
puts i.total

ii = ImportedItem.new(100, 0.05, 0.1)
puts ii.tax_rate
