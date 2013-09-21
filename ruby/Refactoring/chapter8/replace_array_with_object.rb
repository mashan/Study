class Performance
  attr_accessor :name
  attr_writer :wins

  def wins
    @wins.to_i
  end
end

row = Performance.new
row.name = "Liverpool"
row.wins = "15"

p row
