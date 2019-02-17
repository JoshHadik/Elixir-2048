defmodule Elixir2048.Game do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.Vector, as: Vector
  defstruct grid: [[]]

  def new(grid), do: %Game{grid: grid}
  def get_grid(%Game{grid: grid}), do: grid 

  def slide_right(game = %Game { grid: grid }) do
    game |> slide_vectors(:forward)
  end

  def slide_left(game = %Game{}) do
    game |> slide_vectors(:backward)
  end

  defp slide_vectors(game = %Game { grid: grid }, direction) do
    grid |> Enum.map(&(slide_vector(&1, direction))) |> update_grid(game)
  end

  defp slide_vector(vector, direction) do
    vector |> Vector.slide(direction)
  end

  defp update_grid(new_grid, game = %Game { grid: grid }) do
    %Game{ game | grid: new_grid }
  end
end
