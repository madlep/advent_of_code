defmodule Aoc25.Day06 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> Enum.sum_by(&solve_problem/1)
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(fn
        "+" -> &Kernel.+/2
        "*" -> &Kernel.*/2
        value -> String.to_integer(value)
      end)
    end)
    |> Enum.zip_with(fn rows ->
      {rows, [op]} = Enum.split(rows, -1)
      {op, rows}
    end)
  end

  defp solve_problem({op, values}) do
    Enum.reduce(values, op)
  end
end
