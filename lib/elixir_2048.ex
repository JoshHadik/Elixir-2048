defmodule Elixir2048 do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.MoveRight, as: MoveRight
  alias Elixir2048.MoveLeft, as: MoveLeft

  def move_right(list) do
    list
    |> new_game()
    |> MoveRight.call()
    |> return_list()
  end

  def move_left(list) do
    list
    |> new_game()
    |> MoveLeft.call()
    |> return_list()
  end

  defp new_game(list), do: %Game{list: list}
  defp return_list(%Game{list: list}), do: list
end
