defmodule Elixir2048.CLI.Style do

  @_2048_numbers %{
    "2" => [color: :default],
    "4" => [color: :gray],
    "8" => [color: :yellow, style: [:bold]],
    "16" => [color: :light_yellow, style: [:bold]],
    "32" => [color: :red, style: [:bold]],
    "64" => [color: :light_red, style: [:bold]],
    "128" => [color: :blue, style: [:bold]],
    "256" => [color: :cyan, style: [:bold]],
    "512" => [color: :light_cyan, style: [:bold]],
    "1024" => [color: :green, style: [:bold]],
    "2048" => [color: :light_green, style: [:bold]],
    "4096" => [color: :magenta, style: [:bold]],
    "8192" => [color: :light_magenta, style: [:bold]],
    "16384" => [color: :light_cyan, style: [:bold, :underline]],
    "32768" => [color: :light_green, style: [:bold, :underline]],
    "65536" => [color: :light_magenta, style: [:bold, :underline]],
    "131072" => [color: :light_magenta, style: [:bold, :underline, :blink]]
  }

  @colors %{
    gray: 37,
    yellow: 33,
    light_yellow: 93,
    red: 31,
    light_red: 91,
    blue: 34,
    cyan: 36,
    light_cyan: 96,
    green: 32,
    light_green: 92,
    magenta: 35,
    light_magenta: 96,
    default: 39
  }

  @styles %{
    reset: 0,
    bold: 1,
    dim: 2,
    underline: 4,
    blink: 5,
  }

  def format_2048(element) do
    format(element, @_2048_numbers[element])
  end

  def format(element, options \\ [])
  def format(element, []), do: element
  def format(element, [{:color, color} | tail]) do
    format(element |> color(color), tail)
  end

  def format(element, [{:style, styles} | tail]) do
    format(element |> style(styles), tail)
  end

  def style(text, []), do: text
  def style(text, [style | tail]) do
    style(text, style) |> style(tail)
  end

  def style(text, style) do
    wrap_text(text, open: @styles[style], close: @styles[:reset])
  end

  def color(text, color) do
    wrap_text(text, open: @colors[color], close: @colors[:default])
  end

  defp wrap_text(text, open: open, close: close) do
    shell_tag(open) <> text <> shell_tag(close)
  end

  defp shell_tag(number) do
    "\e[#{number}m"
  end
end
