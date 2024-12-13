defmodule Aoc24.Day13 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse_buttons([])
    |> Enum.map(&presses/1)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp presses({ax, ay, bx, by, prizex, prizey}) do
    a = round((bx * -prizey - by * -prizex) / (ax * by - ay * bx))
    b = round((ay * -prizex - ax * -prizey) / (ax * by - ay * bx))

    if a * ax + b * bx == prizex && a * ay + b * by == prizey do
      a * 3 + b
    else
      0
    end
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
