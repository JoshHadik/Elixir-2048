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

  ## Slide Direction Actions ##

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

  ## Check status of game

  def check_status(game) do
    if is_game_over?(game) do
      {:game_over, game}
    else
      {:in_progress, game}
    end
  end

  # Checks if game is over by first checking for nil spaces, and then testing every possible move direction and checking whether it changed the board or not.
  defp is_game_over?(game = %Game{grid: grid}) do
    !empty_spaces?(grid) &&
    slide_columns(game, :forward) == game &&
    slide_columns(game, :backward) == game &&
    slide_rows(game, :forward) == game &&
    slide_rows(game, :backward) == game
  end

  # Return false if reached the end of all lists and no nil spaces found
  defp empty_spaces?([]), do: false

  # Check for empty spaces in nested list
  defp empty_spaces?([head | tail])
  when is_list(head) do
    empty_spaces?(head) && empty_spaces?(tail)
  end

  # Return true on first nil element
  defp empty_spaces?([nil | _tail]), do: true

  # Continue checking if element was not nil
  defp empty_spaces?([head | tail]) do
    empty_spaces?(tail)
  end

  ## Vector Sliding ##

  # Slide columns up (backward) or down (forward)
  # (transpose is used to convert grid from rows to columns and back)
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
