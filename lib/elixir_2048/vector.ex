defmodule Elixir2048.Vector do
  alias Elixir2048.Vector, as: Vector
  defstruct list: [], values: [], spaces: []

  defp new_vector(list), do: %Vector{list: list}
  defp get_list(%Vector{list: list}), do: list

  @doc """
  Slides all values in `list` a certain `direction` and combines adjacent pairs. When `direction` is `:forward` it moves all non-nil elements to right side of list and combines pairs from right to left, when `direction` is `:backward` it moves non-nil elements to left side of list and combines pairs from left to right

  ## Forward Example
      iex> list = [2, nil, 2, 2, 4]
      iex> Elixir2048.Vector.slide(list, :forward)
      [nil, nil, 2, 4, 4]

  ## Backward Example
      iex> list = [2, nil, 2, 2, 4]
      iex> Elixir2048.Vector.slide(list, :backward)
      [4, 2, 4, nil, nil]
  """
  def slide(list, direction)

  # Combine matches from last to first and add spaces to front
  def slide(list, :forward) do
    list |> slide_list(combine_from: :last_to_first, add_spaces_to: :front)
  end

  # Combine matches from first to last and add spaces to back
  def slide(list, :backward) do
    list |> slide_list(combine_from: :first_to_last, add_spaces_to: :back)
  end

  # Conver list into vector, perform sliding logic, and return new list
  defp slide_list(list, combine_from: direction, add_spaces_to: side) do
    list
    |> new_vector()
    |> separate_values_and_spaces()
    |> combine_matched_values(direction)
    |> add_spaces(side)
    |> get_list()
  end

  # Convert vector list into two separate lists:
  # One for (empty) spaces and one for values.
  defp separate_values_and_spaces(vector = %Vector{list: list}) do
    %Vector{ List.foldr(list, vector, &add_space_or_value/2) | list: []}
  end

  # Add space (nil) to spaces list when value is nil
  defp add_space_or_value(space, vector = %Vector{spaces: spaces})
  when is_nil(space) do
    %Vector{ vector | spaces: [space | spaces]}
  end

  # Add value (integer) to values list when value is not nil
  defp add_space_or_value(value, vector = %Vector{values: values}) do
    %Vector{ vector | values: [value | values] }
  end

  # Combine first matching values from first element and to last
  # [2, 2, 2] => [4, 2]
  defp combine_matched_values(vector = %Vector{values: values}, :first_to_last) do
    values
    |> combine_pairs()
    |> add_new_values(vector)
  end

  # Combine first matching values from last element and to first
  # [2, 2, 2] => [2, 4]
  defp combine_matched_values(vector = %Vector{values: values}, :last_to_first) do
    values
    |> Enum.reverse()
    |> combine_pairs()
    |> Enum.reverse()
    |> add_new_values(vector)
  end

  # Combine all pairs from first element to last
  # Enum.reverse() is used in last_to_first to change direction
  defp combine_pairs([]), do: []
  defp combine_pairs([v1, v2 | tail]) when v1 == v2 do
    [ v1 + v2 | combine_pairs(tail) ]
  end

  defp combine_pairs([v1 | tail]) do
    [ v1 | combine_pairs(tail) ]
  end

  # Add new values with matched values back to list
  # Also add new spaces when values were matched
  # (because they merge together and create a missing space)
  defp add_new_values(new_values, vector) do
    %Vector{ vector |
      list: new_values,
      spaces: vector.spaces ++ missing_spaces(vector.values, new_values),
      values: [] }
  end

  # Create list of empty (nil) spaces based on original length of value and new length of matched values
  # eg: original values of [2, 2, 2] matched down to [2, 4] will create one empty space [nil], because length of original values (3) minus length of new values (2) is 1.
  defp missing_spaces(values, new_values) do
    List.duplicate(nil, (length(values) - length(new_values)))
  end

  # Add spaces to back of list
  defp add_spaces(vector = %Vector{list: list, spaces: spaces}, :back) do
    %Vector{ vector | list: list ++ spaces, spaces: [] }
  end

  # Add spaces to front of list
  defp add_spaces(vector = %Vector{list: list, spaces: spaces}, :front) do
    %Vector{ vector | list: spaces ++ list, spaces: [] }
  end
end
