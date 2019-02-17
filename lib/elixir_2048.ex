defmodule Elixir2048 do
  alias Elixir2048.Vector, as: Vector

  def move_right(list) do
    list |> Vector.new() |> Vector.move_right() |> return_list()
  end

  def move_left(list) do
    list |> Vector.new() |> Vector.move_left() |> return_list()
  end

  defp return_list(%Vector{list: list}), do: list
end
