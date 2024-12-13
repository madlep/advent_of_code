defmodule Aoc24.Day13 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input), do: run(input, 0)

  @spec part2(String.t()) :: integer()
  def part2(input), do: run(input, 10_000_000_000_000)

  defp run(input, conversion_error) do
    input
    |> parse_buttons([])
    |> Enum.map(&presses(&1, conversion_error))
    |> Enum.sum()
  end

  defp presses({ax, ay, bx, by, prizex, prizey}, conversion_error) do
    prizex = prizex + conversion_error
    prizey = prizey + conversion_error
    a = round((bx * -prizey - by * -prizex) / (ax * by - ay * bx))
    b = round((ay * -prizex - ax * -prizey) / (ax * by - ay * bx))
    if a * ax + b * bx == prizex && a * ay + b * by == prizey, do: a * 3 + b, else: 0
  end

  defp parse_buttons("", acc), do: Enum.reverse(acc)

  defp parse_buttons(input, acc) do
    {ax, input} = input |> drop("Button A: X+") |> int()
    {ay, input} = input |> drop(", Y+") |> int()
    {bx, input} = input |> drop("\nButton B: X+") |> int()
    {by, input} = input |> drop(", Y+") |> int()
    {prizex, input} = input |> drop("\nPrize: X=") |> int()
    {prizey, input} = input |> drop(", Y=") |> int()
    input = input |> drop("\n")
    parse_buttons(input, [{ax, ay, bx, by, prizex, prizey} | acc])
  end
end
