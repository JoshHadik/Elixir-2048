defmodule Elixir2048.MoveLeft do
  alias Elixir2048.Combinator, as: Combinator
  alias Elixir2048.Game, as: Game

  def call(game) do
    game
    |> get_all_values()
    |> Combinator.combine_matched_values(:left_to_right)
    |> add_spaces_to_list()
  end

  defp get_all_values(game = %Game{list: list}) do
    %Game{ List.foldr(list, game, &add_value/2) | list: []}
  end

  defp add_value(val, game = %Game{spaces: spaces}) when is_nil(val) do
    %Game{ game | spaces: spaces + 1}
  end

  defp add_value(val, game = %Game{values: values}) do
    %Game{ game | values: [val | values] }
  end

  defp add_spaces_to_list(game = %Game{spaces: 0}), do: game
  defp add_spaces_to_list(game = %Game{list: list, spaces: spaces}) do
    %Game{ game | list: list ++ [nil], spaces: spaces - 1}
    |> add_spaces_to_list()
  end
end
