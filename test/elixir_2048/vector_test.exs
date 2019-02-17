defmodule Elixir2048.VectorTest do
  use ExUnit.Case
  doctest Elixir2048.Vector
  
  alias Elixir2048.Vector, as: Vector

  describe "#slide(:forward)" do
    test "moves single element in list all the way to right side" do
      assert Vector.slide([nil, 2, nil, nil], :forward) == [nil, nil, nil, 2]
      assert Vector.slide([2, nil , nil, nil], :forward) == [nil, nil, nil, 2]
      assert Vector.slide([nil , nil, nil, 2], :forward) == [nil, nil, nil, 2]
    end

    test "moves mismatched elements in list all the way to right side" do
      assert Vector.slide([4, 2, nil, nil], :forward) == [nil, nil, 4, 2]
      assert Vector.slide([2, nil, 16, nil], :forward) == [nil, nil, 2, 16]
      assert Vector.slide([2, 32, nil, 64], :forward) == [nil, 2, 32, 64]
    end

    test "adds matched elements before moving to right" do
      assert Vector.slide([2, 2, nil, nil], :forward) == [nil, nil, nil, 4]
      assert Vector.slide([16, 16, nil, 2], :forward) == [nil, nil, 32, 2]
      assert Vector.slide([2, 2, 4, 8], :forward) == [nil, 4, 4, 8]
      assert Vector.slide([nil, 2, 2, 2], :forward) == [nil, nil, 2, 4]
    end
  end

  describe "#slide(:backward)" do
    test "moves single element in list all the way to left side" do
      assert Vector.slide([nil, 2, nil, nil], :backward) == [2, nil, nil, nil]
      assert Vector.slide([2, nil , nil, nil], :backward) == [2, nil, nil, nil]
      assert Vector.slide([nil , nil, nil, 2], :backward) == [2, nil, nil, nil]
    end

    test "moves mismatched elements in list all the way to left side" do
      assert Vector.slide([4, 2, nil, nil], :backward) == [4, 2, nil, nil]
      assert Vector.slide([2, nil, 16, nil], :backward) == [2, 16, nil, nil]
      assert Vector.slide([2, 32, nil, 64], :backward) == [2, 32, 64, nil]
    end

    test "adds matched elements before moving to left" do
      assert Vector.slide([2, 2, nil, nil], :backward) == [4, nil, nil, nil]
      assert Vector.slide([16, 16, nil, 2], :backward) == [32, 2, nil, nil]
      assert Vector.slide([16, 16, 2, 2], :backward) == [32, 4, nil, nil]
      assert Vector.slide([2, 2, 4, 8], :backward) == [4, 4, 8, nil]
      assert Vector.slide([nil, 2, 2, 2], :backward) == [4, 2, nil, nil]
    end
  end
end
