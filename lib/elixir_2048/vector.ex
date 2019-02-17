defmodule Elixir2048.Vector do
  alias Elixir2048.Vector, as: Vector
  defstruct list: [], values: [], spaces: []

  # New vector

  def new_vector(list), do: %Vector{list: list}
  def get_list(%Vector{list: list}), do: list

  # Move by direction

  def slide(list, :forward) do
    list |> slide_list(combine_from: :last_to_first, add_spaces_to: :front)
  end

  def slide(list, :backward) do
    list |> slide_list(combine_from: :first_to_last, add_spaces_to: :back)
  end

  defp slide_list(list, combine_from: direction, add_spaces_to: side) do
    list
    |> new_vector()
    |> split_values_and_spaces()
    |> combine_matched_values(direction)
    |> add_spaces_to_list(side)
    |> get_list()
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

  defp combine_matched_values(vector = %Vector{values: values}, :first_to_last) do
    values
    |> combine_pairs()
    |> add_new_values_to_list(vector)
  end

  defp combine_matched_values(vector = %Vector{values: values}, :last_to_first) do
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

  defp add_spaces_to_list(vector = %Vector{list: list, spaces: spaces}, :back) do
    %Vector{ vector | list: list ++ spaces, spaces: [] }
  end

  defp add_spaces_to_list(vector = %Vector{list: list, spaces: spaces}, :front) do
    %Vector{ vector | list: spaces ++ list, spaces: [] }
  end
end
