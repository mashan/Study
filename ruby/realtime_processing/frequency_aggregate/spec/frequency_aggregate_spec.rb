# -*- encoding: UTF-8 -*-
require File.expand_path(('spec_helper'), File.dirname(__FILE__))

describe FrequencyAggregate::Output do
  FREQUENCY_MINIMUM = 0 # (ms)unit
  FREQUENCY_MAXIMUM = 300 # (ms)unit 
  FREQUENCY_SPAN    = 100 # (ms)unit 
  before do
    @time = Time.parse("Thu Sep 1 00:00:00 GMT 2013")

    @inputs = [
      #[ time, key, response_time(ms) ]
      [ @time, 'key00', 0 ], 
      [ @time, 'key00', 100 ], 
      [ @time, 'key00', 300 ], 
      [ @time, 'key01', 200 ], 
      [ @time, 'key01', 300 ], 
      [ @time, 'key01', 400 ], 
      [ @time, 'key01', 500 ], 
    ]

    @expected = {
      @time => {
        'key00' => [ 0, 100, 300 ],
        'key01' => [ 200, 300, 400, 500 ],
      }
    }

    @frequency_aggregate = FrequencyAggregate::Output.new(FREQUENCY_MINIMUM, FREQUENCY_MAXIMUM, FREQUENCY_SPAN)
    @inputs.each do |input|
      @frequency_aggregate.store(input)
    end
  end

  it "new" do
    frequency_aggregate = FrequencyAggregate::Output.new(FREQUENCY_MINIMUM, FREQUENCY_MAXIMUM, FREQUENCY_SPAN)
    pattern_expected = [
      [ "unmatched", nil, nil ],
      [ "under_100", 0, 100 ],
      [ "under_200", 100, 200 ],
      [ "under_300", 200, 300 ]
    ]
    frequency_aggregate.patterns.should == pattern_expected
  end

  it "store" do
    @frequency_aggregate.entries.should == @expected 
  end

  it "generate_result" do
    results = @frequency_aggregate.generate_result

    results[key00_under_100_per].should == 50.0
    results[key00_under_200_per].should == 0.0
    results[key00_under_300_per].should == 50.0
    results[key00_unmatched_per].should == 0.0

    results[key01_under_100_per].should == 0.0
    results[key01_under_200_per].should == 25.0
    results[key01_under_300_per].should == 25.0
    results[key01_unmatched_per].should == 50.0
  end

  it "emit" do
  end
end
