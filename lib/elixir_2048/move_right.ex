defmodule Elixir2048.MoveRight do
  alias Elixir2048.Combinator, as: Combinator
  alias Elixir2048.Game, as: Game

  def call(game) do
    game
    |> get_all_values()
    |> Combinator.combine_matched_values()
    |> add_spaces_to_list()
  end

  defp get_all_values(game = %Game{ list: list }) do
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
    %Game{ game | list: [nil | list], spaces: spaces - 1}
    |> add_spaces_to_list()
  end

  defp add_spaces(game = %Game{spaces: 0}), do: game

  defp add_spaces(game = %Game{list: list, spaces: spaces}) do
    add_spaces(%Game{game |
      list: [nil | list],
      spaces: spaces - 1
    })
  end
end
