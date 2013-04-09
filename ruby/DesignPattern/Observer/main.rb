#Observer1
class Payroll
  def update(changed_employee)
    puts("#{changed_employee.name}' salary is #{changed_employee.salary}!")
  end
end

#Observer2
class TaxMan
  def update(changed_employee)
    puts("#{changed_employee.name}' tax is!")
  end
end

#Subject
class Employee
  attr_reader :name
  attr_accessor :title, :salary

  def initialize( name, title, salary )
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end
end


fred = Employee.new("Fred", "Crane", 30000.0)
payroll = Payroll.new
fred.add_observer(payroll)
fred.salary =35000.5
fred.notify_observers

fred.salary =36000
tax_man = TaxMan.new
fred.add_observer(tax_man)
fred.notify_observers
