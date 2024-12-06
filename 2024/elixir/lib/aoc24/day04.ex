defmodule Aoc24.Day04 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, xs, ys} = parse(input)

    for x <- xs,
        y <- ys,
        dx <- -1..1,
        dy <- -1..1,
        (x + dx * 3) in xs,
        (y + dy * 3) in ys,
        at(grid, x, y) == "X",
        reduce: 0 do
      acc -> acc + if xmas?(grid, x, y, dx, dy), do: 1, else: 0
    end
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {grid, xs, ys} = parse(input)

    for x <- xs,
        y <- ys,
        (x - 1) in xs,
        (x + 1) in xs,
        (y - 1) in ys,
        (y + 1) in ys,
        at(grid, x, y) == "A",
        reduce: 0 do
      acc -> acc + if x_mas?(grid, x, y), do: 1, else: 0
    end
  end

  defp at(g, x, y), do: g |> elem(y) |> elem(x)

  defp xmas?(g, x, y, dx, dy) do
    ~w[M A S] == Enum.map(1..3, &at(g, x + &1 * dx, y + &1 * dy))
  end

  defp x_mas?(g, x, y) do
    corners = [~w[M S], ~w[S M]]

    [at(g, x - 1, y - 1), at(g, x + 1, y + 1)] in corners &&
      [at(g, x - 1, y + 1), at(g, x + 1, y - 1)] in corners
  end

  defp parse(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> String.graphemes() |> List.to_tuple()))
      |> List.to_tuple()

    width = tuple_size(elem(grid, 0))
    height = tuple_size(grid)
    {grid, 0..(width - 1), 0..(height - 1)}
  end
end
