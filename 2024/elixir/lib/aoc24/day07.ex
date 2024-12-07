defmodule Aoc24.Day07 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> Enum.filter(fn {expected, [num | nums]} -> valid?(expected, nums, num) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse()
    |> Enum.filter(fn {expected, [num | nums]} -> valid2?(expected, nums, num) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp valid?(expected, [], expected) do
    true
  end

  defp valid?(expected, [], acc) when expected != acc do
    false
  end

  defp valid?(expected, _, acc) when acc > expected do
    false
  end

  defp valid?(expected, [num | nums], acc) do
    valid?(expected, nums, acc * num) ||
      valid?(expected, nums, acc + num)
  end

  defp valid2?(expected, [], expected) do
    true
  end

  defp valid2?(expected, [], acc) when expected != acc do
    false
  end

  defp valid2?(expected, _, acc) when acc > expected do
    false
  end

  defp valid2?(expected, [num | nums], acc) do
    valid2?(expected, nums, acc * num) ||
      valid2?(expected, nums, acc + num) ||
      valid2?(expected, nums, acc ||| num)
  end

  def n1 ||| n2 do
    n1 * 10 ** ((:math.log10(n2) |> floor()) + 1) + n2
  end

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
