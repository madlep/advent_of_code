defmodule Aoc25.Day04 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> count_accessible()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.flat_map(&parse_cell(&1, y))
  end

  defp parse_cell({".", _x}, _y), do: []
  defp parse_cell({"@", x}, y), do: [{{x, y}, :roll}]

  defp count_accessible(cells) do
    cells
    |> Map.filter(fn {coord, :roll} -> count_neighbours(cells, coord) < 4 end)
    |> Enum.count()
  end

  defp count_neighbours(cells, coord) do
    coord
    |> neighbours()
    |> Enum.filter(&Map.has_key?(cells, &1))
    |> Enum.count()
  end

  defp neighbours({x, y}) do
    for dx <- -1..1, dy <- -1..1, dx != 0 || dy != 0, do: {x + dx, y + dy}
  end
end
