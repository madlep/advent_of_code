defmodule Aoc24.Day11 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, 25)

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, 75)

  def run(input, blinks) do
    input |> line!() |> ints() |> stones_count(blinks, %{}) |> elem(0)
  end

  defp stones_count(stones, blinks, memo) do
    stones
    |> Enum.reduce({0, memo}, fn stone, {total_count, memo} ->
      {count, memo} = stone_count(stone, blinks, memo)
      {total_count + count, Map.put(memo, {stone, blinks}, count)}
    end)
  end

  defp stone_count(stone, blinks, memo) when is_map_key(memo, {stone, blinks}) do
    {memo[{stone, blinks}], memo}
  end

  defp stone_count(stone, 1, memo) do
    count = stone |> blink() |> length()
    {count, memo}
  end

  defp stone_count(stone, blinks, memo) do
    stone
    |> blink()
    |> stones_count(blinks - 1, memo)
  end

  defp blink(0), do: [1]

  defp blink(n) do
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
