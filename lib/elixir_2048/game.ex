defmodule Elixir2048.Game do
  alias Elixir2048.Game, as: Game
  defstruct list: [], values: [], spaces: []

  # New game

  def new(list), do: %Game{list: list}

  # Move by direction

  def move_right(game) do
    game
    |> split_values_and_spaces()
    |> combine_matched_values(:right_to_left)
    |> add_spaces_to_list(:left)
  end

  def move_left(game) do
    game
    |> split_values_and_spaces()
    |> combine_matched_values(:left_to_right)
    |> add_spaces_to_list(:right)
  end

  # Splits Values and Spaces

  def split_values_and_spaces(game = %Game{list: list}) do
    %Game{ List.foldr(list, game, &add_space_or_value/2) | list: []}
  end

  defp add_space_or_value(space, game = %Game{spaces: spaces})
  when is_nil(space) do
    %Game{ game | spaces: [space | spaces]}
  end

  defp add_space_or_value(value, game = %Game{values: values}) do
    %Game{ game | values: [value | values] }
  end

  # Add Combined Values to List

  defp combine_matched_values(game = %Game{values: values}, :left_to_right) do
    values
    |> combine_pairs()
    |> add_new_values_to_list(game)
  end

  defp combine_matched_values(game = %Game{values: values}, :right_to_left) do
    values
    |> Enum.reverse()
    |> combine_pairs()
    |> Enum.reverse()
    |> add_new_values_to_list(game)
  end

  defp combine_pairs([]), do: []
  defp combine_pairs([v1, v2 | tail]) when v1 == v2 do
    [ v1 + v2 | combine_pairs(tail) ]
  end

  defp combine_pairs([v1 | tail]) do
    [ v1 | combine_pairs(tail) ]
  end

  defp add_new_values_to_list(new_values, game) do
    spaces = List.duplicate(nil, (length(game.values) - length(new_values)))
    %Game{ game |
      list: new_values,
      spaces: game.spaces ++ spaces,
      values: [] }
  end

  # Add Spaces to List

  defp add_spaces_to_list(game = %Game{list: list, spaces: spaces}, :right) do
    %Game{ game | list: list ++ spaces, spaces: [] }
  end

  defp add_spaces_to_list(game = %Game{list: list, spaces: spaces}, :left) do
    %Game{ game | list: spaces ++ list, spaces: [] }
  end
end
