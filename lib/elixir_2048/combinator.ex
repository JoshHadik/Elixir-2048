defmodule Elixir2048.Combinator do
  alias Elixir2048.Game, as: Game

  def combine_matched_values(game = %Game{ values: values }) do
    %Game{ game | list: Enum.reverse(values) |> combine_matched_values(), values: []}
  end

  def combine_matched_values([]), do: []

  def combine_matched_values([v1 | [v2 | tail]]) when v1 == v2 do
    [nil | combine_matched_values(tail) ++ [v1 + v2]]
  end

  def combine_matched_values([v1 | tail]) do
    combine_matched_values(tail) ++ [v1]
  end
end
