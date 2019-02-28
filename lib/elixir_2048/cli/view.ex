defmodule Elixir2048.CLI.View do
  alias Elixir2048.Game, as: Game
  alias Elixir2048.CLI.Style, as: Style

  # ALT STYLE

  # defp cell_separator, do: ""
  # defp render_separator(width), do: ""
  #
  # defp left_and_right_padding(total) do
  #   [ left_padding: round(total), right_padding: 0 ]
  # end
  #
  # defp render_element(nil, cell_width) do
  #   String.duplicate("\s", cell_width) <> "."
  # end

  # END ALT STYLE

  def display(game, :game_over) do
    IO.puts "+++++ GAME OVER +++++"
    display(game)
  end

  def display(%Game{grid: grid}) do
    with cell_width = max_cell_width(grid) do
      render_grid(grid, cell_width)
      |> IO.puts()
      "s (left) | e (up) | f (right) | d (down) | q (quit) | r (restart) | w (safety mode)"
      |> IO.puts()
    end
  end

  def safety_mode() do
    String.duplicate("\n", 20) |> IO.puts()
    fake_benchmarks() |> Enum.each(&IO.puts/1)
    fake_benchmarks() |> Enum.each(fn str ->
      :timer.sleep(100) && IO.puts(str)
    end)
  end

  def fake_benchmarks() do
    IO.puts("\n\nBENCHMARKS\n\n")
    IO.puts("milliseconds (ms)")

    Enum.map(1..18, &fake_benchmark_time/1)
    |> Enum.shuffle()
    |> Enum.with_index()
    |> Enum.map(fn {val, index} -> "#{index}  - #{val}ms" end)
  end

  defp fake_benchmark_time(el) do
    (((1000 + el) * (1000 + el) / 2.5 / 1000) |> round()) / 4
  end

  def get_input(message) do
    IO.puts(message) && get_input()
  end

  def get_input() do
    IO.gets("-> ") |> String.trim()
  end

  defp max_cell_width(grid) do
    grid
    |> List.flatten()
    |> Enum.filter( & !is_nil(&1))
    |> Enum.max()
    |> Integer.digits()
    |> length()
    |> (&(&1 + 2)).()
  end

  defp render_grid(grid, cell_width) do
    for row <- grid, into: row_separator(cell_width) do
      render_row(row, cell_width) <> "\n#{row_separator(cell_width)}"
    end
  end

  defp render_row(row, cell_width) do
    for element <- row, into: cell_separator() do
      render_element(element, cell_width)
    end
  end

  defp render_element(nil, cell_width) do
    String.duplicate("\s", cell_width) <> cell_separator()
  end

  defp render_element(element, cell_width) do
    element |> to_string() |> required_padding(cell_width) |> format()
  end

  defp format({string, left_padding: lpad, right_padding: rpad}) do
    (Style.format_2048(string) |> pad(lpad, rpad)) <> cell_separator()
  end

  defp pad(string, left_padding, right_padding) do
    spaces(left_padding) <> string <> spaces(right_padding)
  end

  defp spaces(number) do
    String.duplicate("\s", number)
  end

  defp required_padding(string, cell_width) do
    {string, total_padding(string, cell_width) |> left_and_right_padding()}
  end

  defp total_padding(string, cell_width) do
    (cell_width - String.length(string)) / 2
  end

  defp left_and_right_padding(total) do
    [ left_padding: floor(total), right_padding: ceil(total) ]
  end

  defp floor(total), do: Float.floor(total) |> round()
  defp ceil(total), do: Float.ceil(total) |> round()

  defp cell_separator, do: Style.color("|", :gray)

  defp row_separator(cell_width) do
    cell_width |> row_width() |> render_separator()
  end

  defp render_separator(width) do
    String.duplicate("-", width) <> "\n" |> Style.color(:gray)
  end

  defp row_width(cell_width), do: ((cell_width+1) * 4) + 1
end
