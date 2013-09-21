class Order
  def initialize(customer_name)
    @customer = Customer.create(customer_name)
  end

  def customer_name
    @customer.name
  end

  def customer=(customer_name)
    @customer = Customer.create(customer_name)
  end

  private
  def self.number_of_orders_for(orders, customer)
    orders.select { |order| order.customer == customer }.size
  end
end

class Customer

  Instances = {}

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.create(name)
    Instances[name]
  end

  def self.load_customers
    new("Hoge").store
    new("Fuga").store
    new("Piyo").store
  end

  def store
    Instances[name] = self
  end
end

c = Customer.new("hoge")
