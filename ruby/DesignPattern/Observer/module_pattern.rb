module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

class Employee 
  include Subject
  attr_reader :name, :address
  attr_reader :salary

  def initialize( name, title, salary )
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end

class Payroll
  def update(changed_employee)
    puts("#{changed_employee.name}' salary is #{changed_employee.salary}!")
  end
end

payroll = Payroll.new
fred = Employee.new("Fred", "Crane", 30000.0)
fred.add_observer(payroll)
fred.salary = 35000

