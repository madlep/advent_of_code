defmodule Aoc24.Day04 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    grid = parse(input)
    width = tuple_size(elem(grid, 0))
    height = tuple_size(grid)
    xs = 0..(width - 1)
    ys = 0..(height - 1)

    for x <- xs,
        y <- ys,
        dx <- -1..1,
        dy <- -1..1,
        (x + dx * 3) in xs,
        (y + dy * 3) in ys,
        at(grid, x, y) == "X",
        reduce: 0 do
      acc ->
        acc + if xmas(grid, x, y, dx, dy), do: 1, else: 0
    end
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&(&1 |> String.graphemes() |> List.to_tuple()))
    |> List.to_tuple()
  end

  defp at(grid, x, y), do: grid |> elem(y) |> elem(x)

  defp xmas(grid, x, y, dx, dy) do
    ~w[M A S] == Enum.map(1..3, &at(grid, x + &1 * dx, y + &1 * dy))
  end
end
