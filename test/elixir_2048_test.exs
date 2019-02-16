defmodule Elixir2048Test do
  use ExUnit.Case
  doctest Elixir2048

  describe "move_right" do
    test "moves single element in list all the way to right side" do
      assert Elixir2048.move_right([nil, 2, nil, nil]) == [nil, nil, nil, 2]
      assert Elixir2048.move_right([2, nil , nil, nil]) == [nil, nil, nil, 2]
      assert Elixir2048.move_right([nil , nil, nil, 2]) == [nil, nil, nil, 2]
    end

    test "moves mismatched elements in list all the way to right side" do
      assert Elixir2048.move_right([4, 2, nil, nil]) == [nil, nil, 4, 2]
      assert Elixir2048.move_right([2, nil, 16, nil]) == [nil, nil, 2, 16]
      assert Elixir2048.move_right([2, 32, nil, 64]) == [nil, 2, 32, 64]
    end

    test "adds matched elements before moving to right" do
      assert Elixir2048.move_right([2, 2, nil, nil]) == [nil, nil, nil, 4]
      assert Elixir2048.move_right([16, 16, nil, 2]) == [nil, nil, 32, 2]
      assert Elixir2048.move_right([2, 2, 4, 8]) == [nil, 4, 4, 8]
      assert Elixir2048.move_right([nil, 2, 2, 2]) == [nil, nil, 2, 4]
    end
  end
  #
  # describe "move_left" do
  #   test "moves single element in list all the way to left side" do
  #     assert Elixir2048.move_left([nil, 2, nil, nil]) == [2, nil, nil, nil]
  #     assert Elixir2048.move_left([2, nil , nil, nil]) == [2, nil, nil, nil]
  #     assert Elixir2048.move_left([nil , nil, nil, 2]) == [2, nil, nil, nil]
  #   end
  #
  #   test "moves mismatched elements in list all the way to left side" do
  #     assert Elixir2048.move_left([4, 2, nil, nil]) == [4, 2, nil, nil]
  #     assert Elixir2048.move_left([2, nil, 16, nil]) == [2, 16, nil, nil]
  #     assert Elixir2048.move_left([2, 32, nil, 64]) == [2, 32, 64, nil]
  #   end
  #
  #   test "adds matched elements before moving to left" do
  #     assert Elixir2048.move_left([2, 2, nil, nil]) == [4, nil, nil, nil]
  #     assert Elixir2048.move_left([16, 16, nil, 2]) == [32, 2, nil, nil]
  #     assert Elixir2048.move_left([16, 16, 2, 2]) == [32, 4, nil, nil]
  #     assert Elixir2048.move_left([2, 2, 4, 8]) == [16, nil, nil, nil]
  #     assert Elixir2048.move_left([nil, 2, 2, 2]) == [4, 2, nil, nil]
  #   end
  # end

end


# move_right single list
# move_left single list
# move_right & move_left game grid
# move_up
# move_down
