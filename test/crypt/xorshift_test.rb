require 'test_xorshift_helper'
require 'benchmark'

describe Crypt::Xorshift64Star do
  before do
    @generator = Crypt::Xorshift64Star.new
  end

  it "generates integers when called with an integer argument" do
    10.times do
      mynum = @generator.rand(1000000)
      mynum.must_be_kind_of Integer
      mynum.must_be :>, 0
      mynum.must_be :<, 1000000
    end
  end

  it "generates floats when called with no argument" do
    10.times do
      mynum = @generator.rand()
      mynum.must_be_kind_of Float
      mynum.must_be :>=, 0
      mynum.must_be :<, 1
    end
  end

  it "generates integers even when called with a float argument" do
    10.times do
      mynum = @generator.rand(10.0)
      mynum.must_be_kind_of Integer
      mynum.must_be :>=, 0
      mynum.must_be :<, 10
    end
  end

  it "seeding works correctly" do
    first_generator = Crypt::Xorshift64Star.new(123)
    second_generator = Crypt::Xorshift64Star.new(123)

    ( first_generator == second_generator ).must_equal true

    10.times { first_generator.rand.must_equal second_generator.rand }

    first_generator.seed.must_equal second_generator.seed

    first_generator = Crypt::Xorshift64Star.new(123)
    second_generator = Crypt::Xorshift64Star.new(124)

    ( first_generator == second_generator ).must_equal false
  end

  it "performs as expected when generating a large quantity of numbers" do
    count = 0
    x = nil
    puts "\n"
    100000.times do
      count += 1
      x = @generator.rand(4294967295)
      print [x].pack('V').unpack('H8') if count % 1000 == 0
      if (count % 7000) == 0
        print "\n"
      else
        print " " if count % 1000 == 0
      end
    end
    puts "\n"
  end

  it "benchmark" do
    generator = Crypt::Xorshift64Star.new
    puts "\nBenchmark integer prng generation"
    start = Time.now
    Benchmark.bm {|bm| bm.report { 20000000.times { generator.rand(4294967295) } } }
    finish = Time.now
    puts "20000000 numbers generated in #{(finish - start)} seconds; #{20000000 / (finish - start)} per second"

    puts "\nBenchmark float prng generation"
    start = Time.now
    Benchmark.bm {|bm| bm.report { 20000000.times { generator.rand } } }
    finish = Time.now
    puts "20000000 numbers generated in #{(finish - start)} seconds; #{20000000 / (finish - start)} per second\n"

#    puts "\nBenchmark ranged prng generation"
#    start = Time.now
#    Benchmark.bm {|bm| bm.report { 1000000.times { generator.rand(3..12) } } }
#    finish = Time.now
#    puts "1000000 numbers generated in #{(finish - start)} seconds; #{1000000 / (finish - start)} per second\n"
  end
end
