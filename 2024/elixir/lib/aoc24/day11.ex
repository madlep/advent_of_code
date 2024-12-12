defmodule Aoc24.Day11 do
  @spec part1(String.t()) :: integer()
  import Aoc24.Parse

  def part1(input) do
    stones = input |> line!() |> ints()

    1..25
    |> Enum.reduce(stones, fn _i, stones ->
      stones |> Enum.flat_map(&blink/1)
    end)
    |> length()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  def blink(0), do: [1]

  def blink(n) do
    digits = floor(:math.log10(n)) + 1

    if rem(digits, 2) == 0 do
      divisor = 10 ** div(digits, 2)
      right = rem(n, divisor)
      left = div(n - right, divisor)
      [left, right]
    else
      [n * 2024]
    end
  end
end
