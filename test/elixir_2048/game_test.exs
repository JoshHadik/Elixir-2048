defmodule Elixir2048.GameTest do
  use ExUnit.Case
  doctest Elixir2048.Game

  alias Elixir2048.Game, as: Game

  @input_grid_1 [
    [2  , nil, nil, 16 ],
    [nil, nil, 2  , 4  ],
    [2  , nil, 2  , 2  ],
    [2  , nil, 2  , 4  ]
  ]

  @input_grid_2 [
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

  describe "#slide_right" do
    test "moves all elements in grid to right side with grid 1" do
      expected_grid = [
        [nil, nil, 2  , 16 ],
        [nil, nil, 2  , 4  ],
        [nil, nil, 2  , 4  ],
        [nil, nil, 4  , 4  ]
      ]

      actual_grid =
        @input_grid_1
        |> Game.new()
        |> Game.slide_right()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "moves all elements in grid to right side with grid 2" do
      expected_grid = [
        [2048, 64 , 1024, 32  ],
        [2048, 2  , 16  , 32  ],
        [nil , nil, 128 , 2   ],
        [nil , 2  , 512 , 4   ]
      ]

      actual_grid =
        @input_grid_2
        |> Game.new()
        |> Game.slide_right()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "does not change full grid on slide right" do
      actual_grid =
        @full_grid
        |> Game.new()
        |> Game.slide_right()
        |> Game.get_grid()

      assert actual_grid == @full_grid
    end
  end

  describe "#slide_left" do
    test "moves all elements in grid to left side with grid 1" do
      expected_grid = [
        [2, 16, nil, nil],
        [2, 4 , nil, nil],
        [4, 2 , nil, nil],
        [4, 4 , nil, nil]
      ]

      actual_grid =
        @input_grid_1
        |> Game.new()
        |> Game.slide_left()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "moves all elements in grid to left side with grid 2" do
      expected_grid = [
        [2048, 64 , 1024, 32  ],
        [2048, 2  , 16  , 32  ],
        [128 , 2  , nil , nil ],
        [2   , 512, 4   , nil ]
      ]

      actual_grid =
        @input_grid_2
        |> Game.new()
        |> Game.slide_left()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "does not change full grid on slide left" do
      actual_grid =
        @full_grid
        |> Game.new()
        |> Game.slide_left()
        |> Game.get_grid()

      assert actual_grid == @full_grid
    end
  end

  describe "#slide_up" do
    test "moves all elements in grid to top with grid 1" do
      expected_grid = [
        [4  , nil, 4  , 16 ],
        [2  , nil, 2  , 4  ],
        [nil, nil, nil, 2  ],
        [nil, nil, nil, 4  ]
      ]

      actual_grid =
        @input_grid_1
        |> Game.new()
        |> Game.slide_up()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "moves all elements in grid to top with grid 2" do
      expected_grid = [
        [4096, 64 , 1024, 64  ],
        [128 , 2  , 16  , 2   ],
        [2   , 512, 4   , nil ],
        [nil , nil, nil , nil ]
      ]

      actual_grid =
        @input_grid_2
        |> Game.new()
        |> Game.slide_up()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "does not change full grid on slide up" do
      actual_grid =
        @full_grid
        |> Game.new()
        |> Game.slide_up()
        |> Game.get_grid()

      assert actual_grid == @full_grid
    end
  end

  describe "#slide_down" do
    test "moves all elements in grid to bottom with grid 1" do
      expected_grid = [
        [nil, nil, nil, 16 ],
        [nil, nil, nil, 4  ],
        [2  , nil, 2  , 2  ],
        [4  , nil, 4  , 4  ]
      ]

      actual_grid =
        @input_grid_1
        |> Game.new()
        |> Game.slide_down()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "moves all elements in grid to bottom with grid 2" do
      expected_grid = [
        [nil , nil, nil , nil ],
        [4096, 64 , 1024, nil ],
        [128 , 2  , 16  , 64 ],
        [2   , 512, 4   , 2   ]
      ]

      actual_grid =
        @input_grid_2
        |> Game.new()
        |> Game.slide_down()
        |> Game.get_grid()

      assert actual_grid == expected_grid
    end

    test "does not change full grid on slide down" do
      actual_grid =
        @full_grid
        |> Game.new()
        |> Game.slide_down()
        |> Game.get_grid()

      assert actual_grid == @full_grid
    end
  end

  describe "#check_status" do
    test "returns {:in_progress, game} when game not full" do
      game1 = Game.new(@input_grid_1)
      assert Game.check_status(game1) == {:in_progress, game1}
      game2 = Game.new(@input_grid_2)
      assert Game.check_status(game2) == {:in_progress, game2}
    end

    test "returns {:game_over, game} when game is full" do
      game_over = Game.new(@full_grid)
      assert Game.check_status(game_over) == {:game_over, game_over}
    end
  end
end
