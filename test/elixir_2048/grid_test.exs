defmodule Elixir2048.GridTest do
  use ExUnit.Case
  doctest Elixir2048.Grid

  alias Elixir2048.Grid, as: Grid

  describe "Elixir2048.Grid.empty_grid_of_size()" do
    test "creates 2x2 grid of nil elements when passed 2" do
      assert Elixir2048.Grid.empty_grid_of_size(2) == [
        [nil, nil],
        [nil, nil]
      ]
    end

    test "creates 4x4 grid of nil elements when passed 4" do
      assert Elixir2048.Grid.empty_grid_of_size(4) == [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil]
      ]
    end

    test "creates 6x6 grid of nil elements when passed 6" do
      assert Elixir2048.Grid.empty_grid_of_size(6) == [
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil]
      ]
    end
  end

  describe "Elixir2048.Grid.populate_2_or_4_randomly()" do
    test "adds either 2 or 4 to grid once when passed no repeat option" do
      grid = Grid.empty_grid_of_size(4) |> Grid.populate_2_or_4_randomly()
      assert number_of_2s_and_4s_in_grid(grid) == 1
    end

    test "adds either 2 or 4 to grid twice when passed 2" do
      grid = Grid.empty_grid_of_size(4) |> Grid.populate_2_or_4_randomly(2)
      assert number_of_2s_and_4s_in_grid(grid) == 2
    end

    test "adds either 2 or 4 to grid four times when passed 4" do
      grid = Grid.empty_grid_of_size(4) |> Grid.populate_2_or_4_randomly(4)
      assert number_of_2s_and_4s_in_grid(grid) == 4
    end

    defp number_of_2s_and_4s_in_grid(grid) do
      grid
      |> List.flatten()
      |> Enum.filter(&(&1 == 2 || &1 == 4))
      |> length()
    end
  end

  @grid_1 [
    [2  , nil, nil, 16 ],
    [nil, nil, 2  , 4  ],
    [2  , nil, 2  , 2  ],
    [2  , nil, 2  , 4  ]
  ]

  @grid_2 [
    [2048, 64 , 1024, 32  ],
    [2048, 2  , 16  , 32  ],
    [128 , nil, 2   , nil ],
    [2   , 512, 2   , 2   ]
  ]

  @full_grid [
    [ 2 , 4, 8, 16],
    [ 16, 8, 4, 2 ],
    [ 2 , 4, 8, 16],
    [ 16, 8, 4, 2 ]
  ]

  describe "Elixir2048.Grid.slide_rows(:forward)" do
    test "moves all elements in grid to right side with grid 1" do
      assert @grid_1 |> Grid.slide_rows(:forward) == [
        [nil, nil, 2  , 16 ],
        [nil, nil, 2  , 4  ],
        [nil, nil, 2  , 4  ],
        [nil, nil, 4  , 4  ]
      ]
    end

    test "moves all elements in grid to right side with grid 2" do
      assert @grid_2 |> Grid.slide_rows(:forward) == [
        [2048, 64 , 1024, 32  ],
        [2048, 2  , 16  , 32  ],
        [nil , nil, 128 , 2   ],
        [nil , 2  , 512 , 4   ]
      ]
    end

    test "does not change full grid on slide right" do
      assert @full_grid |> Grid.slide_rows(:forward) == @full_grid
    end
  end

  describe "Elixir2048.Grid.slide_rows(:backward)" do
    test "moves all elements in grid to left side with grid 1" do
      assert @grid_1 |> Grid.slide_rows(:backward) == [
        [2, 16, nil, nil],
        [2, 4 , nil, nil],
        [4, 2 , nil, nil],
        [4, 4 , nil, nil]
      ]
    end

    test "moves all elements in grid to left side with grid 2" do
      assert @grid_2 |> Grid.slide_rows(:backward) == [
        [2048, 64 , 1024, 32  ],
        [2048, 2  , 16  , 32  ],
        [128 , 2  , nil , nil ],
        [2   , 512, 4   , nil ]
      ]
    end

    test "does not change full grid on slide left" do
      assert @full_grid |> Grid.slide_rows(:backward) == @full_grid
    end
  end

  describe "Elixir2048.Grid.slide_columns(:forward)" do
    test "moves all elements in grid to bottom with grid 1" do
      assert @grid_1 |> Grid.slide_columns(:forward) == [
        [nil, nil, nil, 16 ],
        [nil, nil, nil, 4  ],
        [2  , nil, 2  , 2  ],
        [4  , nil, 4  , 4  ]
      ]
    end

    test "moves all elements in grid to bottom with grid 2" do
      assert @grid_2 |> Grid.slide_columns(:forward) == [
        [nil , nil, nil , nil ],
        [4096, 64 , 1024, nil ],
        [128 , 2  , 16  , 64 ],
        [2   , 512, 4   , 2   ]
      ]
    end

    test "does not change full grid on slide down" do
      assert @full_grid |> Grid.slide_columns(:forward) == @full_grid
    end
  end

  describe "Elixir2048.Grid.slide_columns(:backward)" do
    test "moves all elements in grid to top with grid 1" do
      assert @grid_1 |> Grid.slide_columns(:backward) == [
        [4  , nil, 4  , 16 ],
        [2  , nil, 2  , 4  ],
        [nil, nil, nil, 2  ],
        [nil, nil, nil, 4  ]
      ]
    end

    test "moves all elements in grid to top with grid 2" do
      assert @grid_2 |> Grid.slide_columns(:backward) == [
        [4096, 64 , 1024, 64  ],
        [128 , 2  , 16  , 2   ],
        [2   , 512, 4   , nil ],
        [nil , nil, nil , nil ]
      ]
    end

    test "does not change full grid on slide up" do
      assert @full_grid |> Grid.slide_columns(:backward) == @full_grid
    end
  end

  describe "Elixir2048.Grid.remaining_moves?" do
    test "returns true when grid is not full" do
      assert Grid.remaining_moves?(@grid_1) == true
      assert Grid.remaining_moves?(@grid_2) == true
    end

    test "returns true when grid is full but can move up or down" do
      grid = [[2, 4], [2, 4]]
      assert Grid.remaining_moves?(grid) == true
    end

    test "returns true when grid is full but can move left or right" do
      grid = [[2, 2], [4, 4]]
      assert Grid.remaining_moves?(grid) == true
    end

    test "returns false when grid is full" do
      assert Grid.remaining_moves?(@full_grid) == false
    end
  end
end
