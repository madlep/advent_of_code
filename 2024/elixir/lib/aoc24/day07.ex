defmodule Aoc24.Day07 do
  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, [&Kernel.+/2, &Kernel.*/2])

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, [&Kernel.+/2, &Kernel.*/2, &|||/2])

  defp run(input, ops) do
    input
    |> parse()
    |> Enum.filter(fn {expected, [num | nums]} -> valid?(expected, nums, ops, num) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid?(expected, [], _ops, acc), do: expected == acc

  defp valid?(expected, _, _ops, acc) when acc > expected, do: false

  defp valid?(expected, [num | nums], ops, acc) do
    Enum.any?(ops, &valid?(expected, nums, ops, &1.(acc, num)))
  end

  defp n1 ||| n2, do: n1 * 10 ** ((:math.log10(n2) |> floor()) + 1) + n2

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {expected, rest} = Integer.parse(line)
      <<":", rest::binary>> = rest
      nums = rest |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      {expected, nums}
    end)
  end
end
