defmodule Elixir2048.Grid do
  alias Elixir2048.Vector, as: Vector

  @doc """
  Creates a new grid of all nil elements with number of columns and rows equal to `size`.

  ## Example
      iex> Elixir2048.Grid.empty_grid_of_size(4)
      [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil]
      ]
  """
  def empty_grid_of_size(size) do
    nil
    |> List.duplicate(size)
    |> List.duplicate(size)
  end

  @doc """
  Randomly assigns either the value 2 or 4 to a random empty spaces in `grid` and repeats this operation `repeat` times.

  ## Example
      iex> Elixir2048.Grid.empty_grid_of_size(4) |>
      iex> Elixir2048.Grid.populate_2_or_4_randomly(5) |>
      iex> List.flatten() |> Enum.filter(&(&1 == 2 || &1 == 4)) |> length()
      5
  """
  def populate_2_or_4_randomly(grid, repeat \\ 1)
  def populate_2_or_4_randomly(grid, 0), do: grid
  def populate_2_or_4_randomly(grid, repeat) do
    get_2_or_4_randomly()
    |> add_to_random_space_in_grid(grid)
    |> populate_2_or_4_randomly(repeat - 1)
  end

  # Returns 2 ~75% of the time, and 4 ~25% of the time.
  defp get_2_or_4_randomly(), do: Enum.random([2, 2, 2, 4])

  # Adds value to random empty space in grid
  defp add_to_random_space_in_grid(value, grid) do
    grid
    |> get_location_of_all_spaces
    |> Enum.random()
    |> add_value_at_position(grid, value)
  end

  import Enum, only: [with_index: 1]

  # Returns list of tuples containing {row, col} coordinate tuples for all empty spaces in grid
  defp get_location_of_all_spaces(grid) do
    for {row, x} <- with_index(grid), {el, y} <- with_index(row), el == nil do
      {x, y}
    end
  end

  # Adds value to specific {row, col} coordinate in grid
  defp add_value_at_position({row, col}, grid, value) do
    put_in(grid, [Access.at(row), Access.at(col)], value)
  end

  @doc """
  Slides all columns in `grid` a specific `direction`. Moves elements up when `direction` is `:backward` and moves elements down when `direction` is `:forward`.

  ## Forward Example
      iex> grid = [[nil, 2, nil, 8], [nil, 2, nil, nil], [2, nil, 4, nil], [nil, nil, nil, 8]]
      iex> Elixir2048.Grid.slide_columns(grid, :forward)
      [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [2  , 4  , 4  , 16 ]
      ]

  ## Backward Example
      iex> grid = [[nil, 2, nil, 8], [nil, 2, nil, nil], [2, nil, 4, nil], [nil, nil, nil, 8]]
      iex> Elixir2048.Grid.slide_columns(grid, :backward)
      [
        [2  , 4  , 4  , 16 ],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil]
      ]
  """
  def slide_columns(grid, direction) do
    grid
    |> transpose()
    |> slide_vectors(direction)
    |> transpose()
  end

  # Convert grid of rows to grid of columns (or vice versa)
  defp transpose(grid) do
    grid |> Enum.zip() |> Enum.map(&Tuple.to_list(&1))
  end

  @doc """
  Slides all rows in `grid` a specific `direction`. Moves elements to the right when `direction` is `:forward` and to the left when `direction` is `:backward`.

  ## Forward Example
      iex> grid = [[nil, 2, nil, 2], [nil, 2, nil, nil], [4, nil, 4, nil],[nil, 2, nil, 8 ]]
      iex> Elixir2048.Grid.slide_rows(grid, :forward)
      [
        [nil, nil, nil, 4 ],
        [nil, nil, nil, 2 ],
        [nil, nil, nil, 8 ],
        [nil, nil, 2  , 8 ]
      ]

  ## Backward Example
      iex> grid = [[nil, 2, nil, 2], [nil, 2, nil, nil], [4, nil, 4, nil],[nil, 2, nil, 8 ]]
      iex> Elixir2048.Grid.slide_rows(grid, :backward)
      [
        [4, nil, nil, nil ],
        [2, nil, nil, nil ],
        [8, nil, nil, nil ],
        [2, 8  , nil, nil ]
      ]
  """
  def slide_rows(grid, direction) do
    grid
    |> slide_vectors(direction)
  end

  # Slide all columns or rows forward or backward
  defp slide_vectors(grid, direction) do
    grid |> Enum.map(&(slide_vector(&1, direction)))
  end

  # Slide an individual column or row forward or backward
  defp slide_vector(vector, direction) do
    vector |> Vector.slide(direction)
  end

  @doc """
  Checks if there are any possible moves left in `grid`. Returns true when `grid` has empty spaces (nil elements), or any pairs that can be combined, returns false when `grid` is completely full (no nil elements) and cannot combine pairs in any direction.

  ## Example 1
      iex> grid = [[nil, 2], [2, 4]]
      iex> Elixir2048.Grid.remaining_moves?(grid)
      true

  ## Example 2
      iex> grid = [[2, 2], [8, 4]]
      iex> Elixir2048.Grid.remaining_moves?(grid)
      true

  ## Example 3
      iex> grid = [[2, 4], [8, 16]]
      iex> Elixir2048.Grid.remaining_moves?(grid)
      false
  """
  def remaining_moves?(grid) do
    # First check for empty spaces (to avoid extra computation during game play), then test if each possible move direction changes the grid.
    empty_spaces?(grid) || possible_moves?(grid)
  end

  defp possible_moves?(grid) do
    slide_rows(grid, :forward)     != grid ||
    slide_rows(grid, :backward)    != grid ||
    slide_columns(grid, :forward)  != grid ||
    slide_columns(grid, :backward) != grid
  end

  # Return false if reached the end of all lists and no nil spaces found
  defp empty_spaces?([]), do: false

  # Check for empty spaces in nested list
  defp empty_spaces?([head | tail]) when is_list(head) do
    empty_spaces?(head) || empty_spaces?(tail)
  end

  # Return true on first nil element
  defp empty_spaces?([nil | _tail]), do: true

  # Continue checking if element was not nil
  defp empty_spaces?([_head | tail]) do
    empty_spaces?(tail)
  end
end
