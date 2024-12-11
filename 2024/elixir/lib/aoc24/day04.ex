defmodule Aoc24.Day04 do
  import Aoc24.Parse

  alias Aoc24.Grid.Dense

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, _} = grid(input)

    for x <- Dense.xs(grid),
        y <- Dense.ys(grid),
        dx <- -1..1,
        dy <- -1..1,
        (x + dx * 3) in Dense.xs(grid),
        (y + dy * 3) in Dense.ys(grid),
        Dense.at!(grid, {x, y}) == "X",
        reduce: 0 do
      acc -> acc + if xmas?(grid, x, y, dx, dy), do: 1, else: 0
    end
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {grid, _} = grid(input)

    for x <- Dense.xs(grid),
        y <- Dense.ys(grid),
        (x - 1) in Dense.xs(grid),
        (x + 1) in Dense.xs(grid),
        (y - 1) in Dense.ys(grid),
        (y + 1) in Dense.ys(grid),
        Dense.at!(grid, {x, y}) == "A",
        reduce: 0 do
      acc -> acc + if x_mas?(grid, x, y), do: 1, else: 0
    end
  end

  defp xmas?(g, x, y, dx, dy) do
    ~w[M A S] == Enum.map(1..3, &Dense.at!(g, {x + &1 * dx, y + &1 * dy}))
  end

  defp x_mas?(g, x, y) do
    corners = [~w[M S], ~w[S M]]

    [Dense.at!(g, {x - 1, y - 1}), Dense.at!(g, {x + 1, y + 1})] in corners &&
      [Dense.at!(g, {x - 1, y + 1}), Dense.at!(g, {x + 1, y - 1})] in corners
  end
end
