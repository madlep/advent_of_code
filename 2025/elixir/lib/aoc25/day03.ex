defmodule Aoc25.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse/1)
    |> Stream.map(&largest_jolt/1)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(line), do: line |> String.to_integer() |> Integer.digits()

  def largest_jolt(bank) do
    # n1 can't be last
    n1 = bank |> Enum.drop(-1) |> Enum.max()

    {_bank_head, [^n1 | bank_rest]} = Enum.split_while(bank, &(&1 < n1))
    n2 = Enum.max(bank_rest)

    n1 * 10 + n2
  end
end
