# -*- encoding: UTF-8 -*-
require File.expand_path(('spec_helper'), File.dirname(__FILE__))

describe FrequencyAggregate::Output do
  FREQUENCY_MINIMUM = 0 # (ms)unit
  FREQUENCY_MAXIMUM = 300 # (ms)unit 
  FREQUENCY_SPAN    = 100 # (ms)unit 
  before do
    @inputs = [
      #[ key, response_time(ms) ]
      [ 'key00', 0 ], 
      [ 'key00', 100 ], 
      [ 'key00', 300 ], 
      [ 'key01', 200 ], 
      [ 'key01', 300 ], 
      [ 'key01', 400 ], 
      [ 'key01', 500 ], 
    ]

    @frequency_aggregate = FrequencyAggregate::Output.new(FREQUENCY_MINIMUM, FREQUENCY_MAXIMUM, FREQUENCY_SPAN)

    @inputs.each do |input|
      @frequency_aggregate.store(input)
    end
  end

  it "new" do
    pattern_expected = [
      [ "under100", Range.new(1, 100) ],
      [ "under200", Range.new(101, 200) ],
      [ "under300", Range.new(201, 300) ]
    ]
    @frequency_aggregate.patterns.should == pattern_expected
  end

  it "store" do
    stored_expected = {
      'key00_total' => 3,
      'key00_unmatched' => 1,
      'key00_under100' => 1,
      'key00_under300' => 1,
      'key01_total' => 4,
      'key01_unmatched' => 2,
      'key01_under200' => 1,
      'key01_under300' => 1,
    }

    @frequency_aggregate.counts.sort.should == stored_expected.sort
  end

  it "generate_result" do
    results = @frequency_aggregate.generate_result

    results["key00_under100_per"].should == 33.3
    results["key00_under300_per"].should == 33.3
    results["key00_unmatched_per"].should == 33.3

    results["key01_under200_per"].should == 25.0
    results["key01_under300_per"].should == 25.0
    results["key01_unmatched_per"].should == 50.0
  end
end
