class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly'
    @text = [ 'OK', 'Excellent' ]
    @formatter = formatter
  end

  def output_report
#    @formatter.output_report( @title, @text )
    @formatter.output_report(self)
  end
end
