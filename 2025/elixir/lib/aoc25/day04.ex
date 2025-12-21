defmodule Aoc25.Day04 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> count_accessible()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse()
    |> remove_accessible
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

  defp count_accessible(grid) do
    grid
    |> find_accessible()
    |> Enum.count()
  end

  defp remove_accessible(grid, acc \\ 0)

  defp remove_accessible(grid, acc) do
    case find_accessible(grid) do
      [] -> acc
      coords -> remove_accessible(Map.drop(grid, coords), acc + length(coords))
    end
  end

  defp find_accessible(grid) do
    grid
    |> Map.keys()
    |> Enum.filter(fn coord -> count_neighbours(grid, coord) < 4 end)
  end

  defp count_neighbours(grid, coord) do
    coord
    |> neighbours()
    |> Enum.filter(&Map.has_key?(grid, &1))
    |> Enum.count()
  end

  defp neighbours({x, y}) do
    for dx <- -1..1, dy <- -1..1, dx != 0 || dy != 0, do: {x + dx, y + dy}
  end
end
