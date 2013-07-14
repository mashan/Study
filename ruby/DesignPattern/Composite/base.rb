#抽象ベースクラス
class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class AddDryIngredidentsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super('Mix that batter up!')
  end

  def get_time_required
    3.0
  end
end

class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each {|task| time += task.get_time_required}
    time
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    add_sub_task( AddDryIngredidentsTask.new )
    add_sub_task( MixTask.new )
  end
end

#composite = CompositeTask.new('cake')
#p composite(MakeBatterTask.new)

batter_task = MakeBatterTask.new
puts batter_task.get_time_required
