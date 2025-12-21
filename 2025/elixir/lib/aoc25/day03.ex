defmodule Aoc25.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, 2)

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, 12)

  defp run(input, batteries) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse/1)
    |> Stream.map(&largest_jolt(&1, batteries))
    |> Enum.sum()
  end

  defp parse(line), do: line |> String.to_integer() |> Integer.digits()

  def largest_jolt(bank, batteries, acc \\ [])
  def largest_jolt(_bank, 0, acc), do: acc |> Enum.reverse() |> Integer.undigits()

  def largest_jolt(bank, batteries, acc) do
    n1 = bank |> Enum.drop(1 - batteries) |> Enum.max()

    {_bank_head, [^n1 | bank_rest]} = Enum.split_while(bank, &(&1 < n1))
    largest_jolt(bank_rest, batteries - 1, [n1 | acc])
  end
end
