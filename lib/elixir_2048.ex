defmodule Elixir2048 do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.MoveRight, as: MoveRight

  def move_right(list) do
    %Game{list: list}
    |> MoveRight.call()
    |> return_list
  end

  defp return_list(%Game{list: list}), do: list
end
