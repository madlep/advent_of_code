defmodule Aoc25.Day01 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn n, {pos, count} ->
      case Integer.mod(pos + n, 100) do
        0 -> {0, count + 1}
        new_pos -> {new_pos, count}
      end
    end)
    |> elem(1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn n, {pos, count} ->
      new_pos = pos + rem(n, 100)
      new_count = count + abs(div(n, 100)) + if(pos == 0 || new_pos in 1..99, do: 0, else: 1)
      {Integer.mod(new_pos, 100), new_count}
    end)
    |> elem(1)
  end

  defp parse(input) do
    input
    |> String.splitter("\n", trim: true)
    |> Stream.map(fn
      "R" <> rest -> String.to_integer(rest)
      "L" <> rest -> String.to_integer(rest) * -1
    end)
  end
end
