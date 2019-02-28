defmodule Elixir2048.CLI.Runner do
  alias Elixir2048.Server, as: Server
  alias Elixir2048.CLI.View, as: View

  @actions %{
    "d" => :slide_down,
    "e" => :slide_up,
    "s" => :slide_left,
    "f" => :slide_right,
    "q" => :quit,
    "r" => :restart,
    "w" => :safety
  }

  def main(_argv) do
    self() |> Server.start_game() |> cli_loop()
  end

  def cli_loop(server) do
    receive do
      {:game_over, game} -> game_over(game, server)
      {:in_progress, game} -> new_turn(game, server)
    end
  end

  defp new_turn(game, server) do
    View.display(game)
    View.get_input() |> send_action(server, game)
    cli_loop(server)
  end

  defp send_action(input, server, game) do
    case @actions[input] do
      nil -> new_turn(game, server)
      :quit -> quit(game, server)
      :restart -> restart(game, server)
      :safety -> safety_mode(game, server)
      action -> send(server, action)
    end
  end

  defp quit(game, server) do
    case View.get_input("Are you sure you want to quit? (y/n)") do
      "y" -> IO.puts("Thanks for playing!") && exit(:normal)
      "n" -> new_turn(game, server)
    end
  end

  defp restart(game, server) do
    case View.get_input("Are you sure you want to restart? (y/n)") do
      "y" -> IO.puts("OK!") && send(server, :restart)
      "n" -> new_turn(game, server)
    end
  end

  defp safety_mode(game, server) do
    View.safety_mode()
    View.get_input()
    new_turn(game, server)
  end

  defp game_over(game, _server) do
    View.display(game, :game_over)
    exit(:normal)
  end
end
