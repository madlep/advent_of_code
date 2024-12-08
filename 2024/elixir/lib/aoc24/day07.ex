defmodule Aoc24.Day07 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, [&+/2, &*/2])

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, [&+/2, &*/2, &|||/2])

  defp run(input, ops) do
    input
    |> parse()
    |> Enum.filter(fn {expected, [n | ns]} -> valid?(expected, ns, ops, n) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid?(expected, [], _ops, acc), do: expected == acc

  defp valid?(expected, _, _ops, acc) when acc > expected, do: false

  defp valid?(expected, [n | ns], ops, acc) do
    Enum.any?(ops, &valid?(expected, ns, ops, &1.(acc, n)))
  end

  defp n1 ||| n2, do: n1 * 10 ** ((:math.log10(n2) |> floor()) + 1) + n2

  defp parse(input) do
    input
    |> lines()
    |> Enum.map(fn line ->
      {expected, rest} = int(line)
      {expected, rest |> drop(":") |> ints()}
    end)
  end
end
