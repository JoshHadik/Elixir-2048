defmodule Elixir2048.Combinator do
  alias Elixir2048.Game, as: Game

  def combine_matched_values(game = %Game{ values: values }, direction) do
    values |> get_combined_values(direction) |> add_new_values(game)
  end

  defp get_combined_values(list, :left_to_right) do
    list |> combine_pairs()
  end

  defp get_combined_values(list, :right_to_left) do
    list |> Enum.reverse() |> combine_pairs() |> Enum.reverse()
  end

  defp combine_pairs([]), do: []
  defp combine_pairs([v1, v2 | tail]) when v1 == v2 do
    [ v1 + v2 | combine_pairs(tail) ]
  end

  defp combine_pairs([v1 | tail]) do
    [ v1 | combine_pairs(tail) ]
  end

  defp add_new_values(new_values, game) do
    %Game{ game |
      list: new_values,
      spaces: game.spaces + (length(game.values) - length(new_values)),
      values: [] }
  end
end
