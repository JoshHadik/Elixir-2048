defmodule Elixir2048.Game do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.Vector, as: Vector
  defstruct grid: [[]]

  ## Game Struct Helper Methods ##

  def new(grid), do: %Game{grid: grid}
  def get_grid(%Game{grid: grid}), do: grid

  def update_grid(new_grid, game = %Game{}) do
    %Game{ game | grid: new_grid }
  end

  ## Slide Direction Handlers ##

  def slide_right(game = %Game{}) do
    game |> slide_rows(:forward)
  end

  def slide_left(game = %Game{}) do
    game |> slide_rows(:backward)
  end

  def slide_up(game = %Game{}) do
    game |> slide_columns(:backward)
  end

  def slide_down(game = %Game{}) do
    game |> slide_columns(:forward)
  end

  ## Vector Sliding ##

  # Slide columns up (backward) or down (forward)
  defp slide_columns(game = %Game { grid: grid }, direction) do
    grid
    |> transpose()
    |> Enum.map(&(slide_vector(&1, direction)))
    |> transpose()
    |> update_grid(game)
  end

  # Slide rows right (forward) and left (backward)
  defp slide_rows(game = %Game { grid: grid }, direction) do
    grid
    |> Enum.map(&(slide_vector(&1, direction)))
    |> update_grid(game)
  end

  # Slide an individual column or row forward or backward
  defp slide_vector(vector, direction) do
    vector |> Vector.slide(direction)
  end

  # Convert grid of rows to grid of columns (or vice versa)
  defp transpose(grid) do
    grid |> Enum.zip() |> Enum.map(&Tuple.to_list(&1))
  end
end
