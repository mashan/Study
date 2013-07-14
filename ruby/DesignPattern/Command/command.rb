require 'rubygems'
require 'madeleine'

class Employee
  attr_accessor :name, :number, :address

  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end

  def to_s
    "Employee: name: #{name}  num: #{number}  addr: #{address}"
  end
end

class EmployeeManager
  def initialize
    @employees = {}
  end

  def add_employee(e)
    @employees[e.number] = e
  end

  def change_address(number, address)
    employee = @employees[number]
    raise "No such employee" if not employee
    employee.address = address
  end

  def delete_employee(number)
    @employees.remove(number)
  end

  def find_employee(number)
    @employees[number]
  end
end

class AddEmployee
  def initialize(employee)
    @employee = employee
  end

  def execute(system)
    system.add_employee(@employee)
  end
end

class DeleteEmployee
  def initialize(employee)
    @employee = employee
  end

  def execute(system)
    system.delete_employee(@employee)
  end
end

class ChangeAddress
  def initialize(number, address)
    @number = number
    @address = address
  end

  def execute(system)
    system.change_address(@number, @address)
  end
end

class FindEmployee
  def initialize(number)
    @number = number
  end

  def execute(system)
    system.find_employee(@number)
  end
end

#Compisite相当
store = SnapshotMadeleine.new('employees') {EmployeeManager.new}

Thread.new do
  while true
    sleep(20)
    madeleine.take_snapshot
  end
end

tom = Employee.new('tom', '1', 'hoge')
harry = Employee.new('harry', '2', 'fuga')

store.execute_command(AddEmployee.new(tom))
store.execute_command(AddEmployee.new(harry))

puts(store.execute_command(FindEmployee.new('1')))
puts(store.execute_command(FindEmployee.new('2')))

