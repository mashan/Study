require "frequency_aggregate/version"

module FrequencyAggregate
  class Output
    def initialize(minimum,maximum,span)
      @min  = minimum
      @max  = maximum
      @span = span

      @patterns = []
      @patterns.push([ "unmatched", nil, nil ])
      (@min + @span).step(@max, @span) { |i| 
        min = i - @span 
        max = i
        @patterns.push( [ "under_#{i}", min, max ] )
      }

      @result = Hash.new {0}

      @entries = Hash.new { |entry_per_time,time_key| 
        entry_per_time[time_key] = Hash.new { |entry_per_key,key|
          entry_per_key[key] = []
        }
      }
    end

    attr_accessor :entries, :patterns

    def store(input)
      @entries[input[0]][input[1]].push(input[2])
    end

    def generate_result(time)
      @entries.each do |time_key, entries|
        if time_key <= time
          entries.each do |key, values|
          end
        end
      end
    end

    def emit
    end
  end
end
