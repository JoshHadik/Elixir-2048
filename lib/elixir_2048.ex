defmodule Elixir2048 do
  alias Elixir2048.Game, as: Game

  def move_right(list) do
    list |> Game.new() |> Game.move_right() |> return_list()
  end

  def move_left(list) do
    list |> Game.new() |> Game.move_left() |> return_list()
  end

  defp return_list(%Game{list: list}), do: list
end
