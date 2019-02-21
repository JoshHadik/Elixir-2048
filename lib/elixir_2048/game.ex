defmodule Elixir2048.Game do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.Grid, as: Grid
  defstruct grid: [[]]

  @grid_size 4

  ## Game Struct Helper Methods ##

  def new(grid), do: %Game{grid: grid}
  def get_grid(%Game{grid: grid}), do: grid

  def update_grid(new_grid, game = %Game{}) do
    %Game{ game | grid: new_grid }
  end

  def new_game(size \\ @grid_size) do
    Grid.empty_grid_of_size(size)
    |> Grid.populate_2_or_4_randomly(2)
    |> update_grid(%Game{})
  end

  ## Slide Direction Actions ##

  def slide_right(game = %Game{grid: grid}) do
    grid |> Grid.slide_rows(:forward) |> update_grid(game)
  end

  def slide_left(game = %Game{grid: grid}) do
    grid |> Grid.slide_rows(:backward) |> update_grid(game)
  end

  def slide_up(game = %Game{grid: grid}) do
    grid |> Grid.slide_columns(:backward) |> update_grid(game)
  end

  def slide_down(game = %Game{grid: grid}) do
    grid |> Grid.slide_columns(:forward) |> update_grid(game)
  end

  ## Check status of game

  def check_status(game = %Game{grid: grid}) do
    if Grid.remaining_moves?(grid) do
      {:in_progress, game}
    else
      {:game_over, game}
    end
  end
end
