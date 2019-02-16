# defmodule Elixir2048.MoveLeft do
#   alias Elixir2048.Game, as: Game
#
#   def call(game) do
#     game
#     |> get_values
#     |> reverse_values
#     |> add_values
#     |> add_spaces
#   end
#
#   # def reverse_values(game = %Game{values: values}) do
#   #   %Game{ game | values: Enum.reverse(values)}
#   # end
#
#   def reverse_values(game = %Game{values: values}) do
#     %Game{ game | values: Enum.reverse(values) }
#   end
#
#   def get_values(game = %Game{list: []}), do: game
#
#   def get_values(game = %Game{list: [head | tail]}) when is_nil(head) do
#     get_values(%Game{game | list: tail, spaces: game.spaces + 1})
#   end
#
#   def get_values(game = %Game{list: [head | tail]}) do
#     get_values(%Game{game | list: tail, values: [head | game.values]})
#   end
#
#   defp add_values(game = %Game{values: [], changes: false}), do: game
#
#   defp add_values(game = %Game{values: [], changes: true}) do
#     add_values(%Game{game |
#       changes: false,
#       values: game.list,
#       list: []
#     })
#   end
#
#   defp add_values(game = %Game{values: [first | [second | tail]]}) when
#     first == second
#   do
#     add_values(%Game{game |
#       list: [first + second | game.list],
#       spaces: game.spaces + 1,
#       values: tail,
#       changes: true
#     })
#   end
#
#   defp add_values(game = %Game{values: [first | tail]}) do
#     add_values(%Game{game |
#       list: [first | game.list],
#       values: tail
#     })
#   end
#
#   defp add_spaces(game = %Game{spaces: 0}), do: game
#
#   defp add_spaces(game = %Game{list: list, spaces: spaces}) do
#     add_spaces(%Game{game |
#       list: list ++ [nil],
#       spaces: spaces - 1
#     })
#   end
# end
