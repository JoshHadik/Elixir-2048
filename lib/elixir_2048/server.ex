defmodule Elixir2048.Server do
  alias Elixir2048.Server, as: Server
  alias Elixir2048.Game, as: Game

  def start_game(runner) do
    game = Game.new_game()
    spawn(Server, :game_loop, [game, runner, :primer])
  end

  def game_loop(game, runner, :primer) do
    send(runner, {:in_progress, game}) && game_loop(game, runner)
  end

  def game_loop(game, runner) do
    receive do
      :restart -> restart_game(runner)
      action -> perform_action(game, action, runner)
    end
  end

  defp restart_game(runner) do
    Game.new_game()
    |> Game.check_status()
    |> send_message(runner)
    |> next_loop(runner)
  end

  defp perform_action(game, action, runner) do
    game
    |> Game.perform(action)
    |> send_message(runner)
    |> next_loop(runner)
  end

  defp next_loop({_status, game}, runner), do: game_loop(game, runner)
  defp send_message(msg, runner), do: send(runner, msg)
end
