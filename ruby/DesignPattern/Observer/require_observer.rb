require 'observer'
class Employee
  include Observable

  attr_reader :name, :address
  attr_reader :salary

  def initialize( name, title, salary )
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end

class Payroll
  def update(changed_employee)
    puts "#{changed_employee.name} is updated! \\#{changed_employee.salary}!"
  end
end

takashi = Employee.new('takashi', 'takashi@takashi.com', 1000000)
payroll = Payroll.new

takashi.add_observer(payroll)
takashi.salary = 1000000
takashi.salary = 2000000
