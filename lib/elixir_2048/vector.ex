defmodule Elixir2048.Vector do
  alias Elixir2048.Vector, as: Vector
  defstruct list: [], values: [], spaces: []

  # New vector

  def new(list), do: %Vector{list: list}

  # Move by direction

  def move_right(vector) do
    vector
    |> split_values_and_spaces()
    |> combine_matched_values(:right_to_left)
    |> add_spaces_to_list(:left)
  end

  def move_left(vector) do
    vector
    |> split_values_and_spaces()
    |> combine_matched_values(:left_to_right)
    |> add_spaces_to_list(:right)
  end

  # Splits Values and Spaces

  def split_values_and_spaces(vector = %Vector{list: list}) do
    %Vector{ List.foldr(list, vector, &add_space_or_value/2) | list: []}
  end

  defp add_space_or_value(space, vector = %Vector{spaces: spaces})
  when is_nil(space) do
    %Vector{ vector | spaces: [space | spaces]}
  end

  defp add_space_or_value(value, vector = %Vector{values: values}) do
    %Vector{ vector | values: [value | values] }
  end

  # Add Combined Values to List

  defp combine_matched_values(vector = %Vector{values: values}, :left_to_right) do
    values
    |> combine_pairs()
    |> add_new_values_to_list(vector)
  end

  defp combine_matched_values(vector = %Vector{values: values}, :right_to_left) do
    values
    |> Enum.reverse()
    |> combine_pairs()
    |> Enum.reverse()
    |> add_new_values_to_list(vector)
  end

  defp combine_pairs([]), do: []
  defp combine_pairs([v1, v2 | tail]) when v1 == v2 do
    [ v1 + v2 | combine_pairs(tail) ]
  end

  defp combine_pairs([v1 | tail]) do
    [ v1 | combine_pairs(tail) ]
  end

  defp add_new_values_to_list(new_values, vector) do
    spaces = List.duplicate(nil, (length(vector.values) - length(new_values)))
    %Vector{ vector |
      list: new_values,
      spaces: vector.spaces ++ spaces,
      values: [] }
  end

  # Add Spaces to List

  defp add_spaces_to_list(vector = %Vector{list: list, spaces: spaces}, :right) do
    %Vector{ vector | list: list ++ spaces, spaces: [] }
  end

  defp add_spaces_to_list(vector = %Vector{list: list, spaces: spaces}, :left) do
    %Vector{ vector | list: spaces ++ list, spaces: [] }
  end
end
