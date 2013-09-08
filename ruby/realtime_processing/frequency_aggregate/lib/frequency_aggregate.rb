require "frequency_aggregate/version"

module FrequencyAggregate
  class Output
    def initialize(minimum,maximum,span)
      @min  = minimum
      @max  = maximum
      @span = span

      @patterns = [] #[ pattern_key, Range ]
      (@min + @span).step(@max, @span) { |i| 
        min = i - @span 
        max = i
        @patterns.push( [ "under#{i}", Range.new( min + 1, max ) ] )
      }

      @counts  = Hash.new {0}
    end

    attr_accessor :counts, :patterns

    def store(input)
      key, value = input
      @counts["#{key}_total"] += 1

      @patterns.each do |pattern|
        if pattern[1].include?(value)
          return @counts["#{key}_#{pattern[0]}"] += 1
        end
      end

      @counts["#{key}_unmatched"] += 1
    end

    def generate_result
      results = Hash.new {0}

      @counts.each do |key, value|
        k,matched = key.split("_")
        next if matched == "total"

        results["#{key}_per"] = sprintf( "%.1f", value.to_f / @counts["#{k}_total"] * 100 ).to_f
      end
      results
    end
  end
end
