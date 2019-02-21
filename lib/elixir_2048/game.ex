defmodule Elixir2048.Game do
  @moduledoc """
  Responsible for the game logic of Elixir 2048. Used to start new games, initiate slide actions on an existing game, and check the status of a game.
  """
  alias Elixir2048.Game, as: Game
  alias Elixir2048.Grid, as: Grid
  defstruct grid: [[]]

  @grid_size 4

  @doc """
  Creates a new game of `size \\\\ 4` and populates randomly with first two values of either 2 or 4.

  ## Example
      iex> new_game = Elixir2048.Game.new_game()
      iex> new_game.grid |> length()
      4
      iex> new_game.grid |> List.flatten() |> length()
      16
      iex> new_game.grid |> List.flatten() |> Enum.filter(&(&1 == 2 || &1 == 4)) |> length()
      2
  """
  def new_game(size \\ @grid_size) do
    Grid.empty_grid_of_size(size)
    |> Grid.populate_2_or_4_randomly(2)
    |> update_grid(%Game{})
  end

  @doc """
  Slides all elements in `:grid` attribute of `game` to the right while combining matched pairs.

  ## Example
      iex> grid = [[nil, 2, nil, 2], [nil, 2, nil, nil], [4, nil, 4, nil],[nil, 2, nil, 8]]
      iex> game = %Elixir2048.Game{ grid: grid }
      iex> game_after_slide_right = Elixir2048.Game.slide_right(game)
      iex> game_after_slide_right.grid
      [
        [nil, nil, nil, 4 ],
        [nil, nil, nil, 2 ],
        [nil, nil, nil, 8 ],
        [nil, nil, 2  , 8 ]
      ]
  """
  def slide_right(game = %Game{grid: grid}) do
    grid |> Grid.slide_rows(:forward) |> update_grid(game)
  end

  @doc """
  Slides all elements in `:grid` attribute of `game` to the left while combining matched pairs.

  ## Example
      iex> grid = [[nil, 2, nil, 2], [nil, 2, nil, nil], [4, nil, 4, nil],[nil, 2, nil, 8]]
      iex> game = %Elixir2048.Game{ grid: grid }
      iex> game_after_slide_left = Elixir2048.Game.slide_left(game)
      iex> game_after_slide_left.grid
      [
        [4, nil, nil, nil ],
        [2, nil, nil, nil ],
        [8, nil, nil, nil ],
        [2, 8  , nil, nil ]
      ]
  """
  def slide_left(game = %Game{grid: grid}) do
    grid |> Grid.slide_rows(:backward) |> update_grid(game)
  end

  @doc """
  Slides all elements in `:grid` attribute of `game` to the top while combining matched pairs.

  ## Example
      iex> grid = [[nil, 2, nil, 8], [nil, 2, nil, nil], [2, nil, 4, nil], [nil, nil, nil, 8]]
      iex> game = %Elixir2048.Game{ grid: grid }
      iex> game_after_slide_up = Elixir2048.Game.slide_up(game)
      iex> game_after_slide_up.grid
      [
        [2  , 4  , 4  , 16 ],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil]
      ]
  """
  def slide_up(game = %Game{grid: grid}) do
    grid |> Grid.slide_columns(:backward) |> update_grid(game)
  end

  @doc """
  Slides all elements in `:grid` attribute of `game` to the bottom while combining matched pairs.

  ## Example
      iex> grid = [[nil, 2, nil, 8], [nil, 2, nil, nil], [2, nil, 4, nil], [nil, nil, nil, 8]]
      iex> game = %Elixir2048.Game{ grid: grid }
      iex> game_after_slide_down = Elixir2048.Game.slide_down(game)
      iex> game_after_slide_down.grid
      [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [2  , 4  , 4  , 16 ]
      ]
  """
  def slide_down(game = %Game{grid: grid}) do
    grid |> Grid.slide_columns(:forward) |> update_grid(game)
  end

  # Updates grid attribute of game.
  defp update_grid(new_grid, game = %Game{}) do
    %Game{ game | grid: new_grid }
  end

  @doc """
  Checks the status of `game`. Returns {`:game_over`, `game`} when no possible moves are remaining, and {`:in_progress`, `game`} otherwise.

  ## Game Over Example
      iex> full_grid = [[2, 4, 8, 16], [32, 64, 128, 256], [512, 1024, 2048, 4096], [8192, 16384, 32768, 65536]]
      iex> game = %Elixir2048.Game{ grid: full_grid }
      iex> Elixir2048.Game.check_status(game) == {:game_over, game}
      true

  ## In Progress Example
      iex> not_full_grid = [[2, nil, nil, 2], [4, nil, 4, 8], [nil, nil, 2, 8], [nil, 16, 32, 64]]
      iex> game = %Elixir2048.Game{ grid: not_full_grid }
      iex> Elixir2048.Game.check_status(game) == {:in_progress, game}
      true
  """
  def check_status(game = %Game{grid: grid}) do
    if Grid.remaining_moves?(grid) do
      {:in_progress, game}
    else
      {:game_over, game}
    end
  end
end
