defmodule Aoc24.Day14 do
  import Aoc24.Parse

  @spec part1(String.t(), keyword()) :: integer()
  def part1(input, opts \\ [w: 101, h: 103]) do
    {w, h} = {opts[:w], opts[:h]}
    {midw, midh} = {div(w, 2), div(h, 2)}

    input
    |> parse()
    |> Enum.map(&move(&1, 100, w, h))
    |> Enum.reject(fn {x, y} -> x == midw || y == midh end)
    |> Enum.group_by(&quadrant(&1, midw, midh))
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(&*/2)
  end

  @spec part2(String.t(), keyword()) :: integer()
  def part2(input, opts \\ [w: 101, h: 103]) do
    {w, h} = {opts[:w], opts[:h]}
    bots = parse(input)

    1..(w * h - 1)
    |> Enum.map(fn i -> {bots |> Enum.map(&move(&1, i, w, h)) |> variance_xy(), i} end)
    |> Enum.min()
    |> elem(1)
  end

  defp move({x, y, dx, dy}, n, w, h) do
    x = rem(x + dx * n, w)
    y = rem(y + dy * n, h)

    x = if x < 0, do: w + x, else: x
    y = if y < 0, do: h + y, else: y

    {x, y}
  end

  defp quadrant({x, y}, midw, midh) when x < midw and y < midh, do: 1
  defp quadrant({x, y}, midw, midh) when x > midw and y < midh, do: 2
  defp quadrant({x, y}, midw, midh) when x < midw and y > midh, do: 3
  defp quadrant({x, y}, midw, midh) when x > midw and y > midh, do: 4

  defp variance_xy(bots) do
    n = length(bots)

    {xs, ys} =
      Enum.reduce(bots, {[], []}, fn {x, y}, {xs, ys} ->
        {[x | xs], [y | ys]}
      end)

    variance(xs, n) + variance(ys, n)
  end

  defp variance(nums, n) do
    mean = Enum.sum(nums) / n
    Enum.sum(Enum.map(nums, fn num -> (num - mean) ** 2 end)) / n
  end

  defp parse(input) do
    # p=0,4 v=3,-3
    input
    |> lines()
    |> Enum.map(fn line ->
      {x, line} = line |> drop("p=") |> int()
      {y, line} = line |> drop(",") |> int()
      {dx, line} = line |> drop(" v=") |> int()
      {dy, ""} = line |> drop(",") |> int()
      {x, y, dx, dy}
    end)
  end
end
