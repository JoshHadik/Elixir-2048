defmodule Elixir2048 do
  defstruct list: [], values: [], spaces: 0, changes: false

  def move_right(list) do
    game =
      %Elixir2048{list: list}
      |> get_values
      |> add_values
      |> add_spaces

    game.list
  end

  def get_values(game = %Elixir2048{list: []}), do: game

  def get_values(game = %Elixir2048{list: [head | tail]}) when is_nil(head) do
    get_values(%Elixir2048{game | list: tail, spaces: game.spaces + 1})
  end

  def get_values(game = %Elixir2048{list: [head | tail]}) do
    get_values(%Elixir2048{game | list: tail, values: ([head | game.values])})
  end

  def add_values(game = %Elixir2048{values: [], changes: false}), do: game

  def add_values(game = %Elixir2048{values: [], changes: true}) do
    add_values(%Elixir2048{game |
      changes: false,
      values: Enum.reverse(game.list),
      list: []
    })
  end

  def add_values(game = %Elixir2048{values: [first | [second | tail]]}) when
    first == second
  do
    add_values(%Elixir2048{game |
      list: [first + second | game.list],
      spaces: game.spaces + 1,
      values: tail,
      changes: true
    })
  end

  def add_values(game = %Elixir2048{values: [first | tail]}) do
    add_values(%Elixir2048{game |
      list: [first | game.list],
      values: tail
    })
  end

  def add_spaces(game = %Elixir2048{spaces: 0}), do: game
  
  def add_spaces(game = %Elixir2048{list: list, spaces: spaces}) do
    add_spaces(%Elixir2048{game |
      list: [nil | list],
      spaces: spaces - 1
    })
  end
end


### OLD VERSION ###

# def move_right([], values, spaces) do
#   spaces
#   |> add_spaces_to_right(values)
# end
#
# def move_right([head | tail], values, spaces) when is_nil(head) do
#   move_right(tail, values, spaces + 1)
# end
#
# def move_right([head | tail], values, spaces) do
#   map = add_value(values, head)
#   move_right(tail, map |> elem(0), spaces + (map |> elem(1)))
# end
#
# defp add_spaces_to_right(0, list), do: list
#
# defp add_spaces_to_right(spaces, list) do
#   [nil | add_spaces_to_right(spaces - 1, list)]
# end
#
# defp add_value([], value), do: {[value], 0}
#
# defp add_value(list = [head | tail], value) when head == value do
#   {[head + value | tail], 1}
# end
#
# defp add_value(list = [head | tail], value) do
#   {(list ++ [value]), 0}
# end
