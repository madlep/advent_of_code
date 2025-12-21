defmodule Aoc25.Day06 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> Enum.sum_by(&solve/1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse()
    |> Enum.sum_by(&solve_cephalopod/1)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 <> " "))
    |> split_cols()
  end

  defp split_cols(lines, acc \\ [])

  defp split_cols(lines, acc) do
    width = col_width(Enum.at(lines, -1))

    if width > 0 do
      {col, rest_lines} =
        lines
        |> Enum.map(&String.split_at(&1, width))
        |> Enum.unzip()

      {values, [op]} =
        col
        |> Enum.map(&String.replace_suffix(&1, " ", ""))
        |> Enum.split(-1)

      split_cols(rest_lines, [{parse_op(op), values} | acc])
    else
      Enum.reverse(acc)
    end
  end

  defp col_width(""), do: 0

  defp col_width(line) do
    case Regex.run(~r/^[\*\+]\s*$/, line, return: :index) do
      [{0, width}] ->
        width

      nil ->
        case Regex.run(~r/^([\*\+]\s*)\s[\*\+]/, line, return: :index) do
          [{0, _full_width}, {0, match_width}] -> match_width + 1
        end
    end
  end

  defp parse_op("+" <> _rest), do: &Kernel.+/2
  defp parse_op("*" <> _rest), do: &Kernel.*/2

  defp solve({op, values}) do
    values
    |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
    |> Enum.reduce(op)
  end

  defp solve_cephalopod({op, values}) do
    Enum.map(values, fn v ->
      v
      |> String.split("", trim: true)
      |> Enum.map(fn digit ->
        case Integer.parse(digit) do
          {n, ""} -> n
          :error -> nil
        end
      end)
    end)
    |> Enum.zip_with(&(&1 |> Enum.filter(fn n -> n end) |> Integer.undigits()))
    |> Enum.reduce(op)
  end
end
