defmodule Elixir2048 do
  alias Elixir2048.Game, as: Game

  def move_right(list) do
    Game.new(list) |> Game.slide_right
  end

  def move_left(list) do
    Game.new(list) |> Game.slide_left
  end

end
