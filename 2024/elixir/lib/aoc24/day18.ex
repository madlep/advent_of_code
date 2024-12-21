defmodule Aoc24.Day18 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position
  alias Aoc24.Grid.Sparse

  @spec part1(String.t()) :: integer()
  def part1(input, n \\ 1024, w \\ 70, h \\ 70) do
    input
    |> parse()
    |> Enum.take(n)
    |> Enum.reduce(Sparse.new(w + 1, h + 1), fn pos, grid -> Grid.put(grid, pos, "#") end)
    |> walk({0, 0}, 0, %{})
    |> Map.get({w, h})
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp walk(grid, pos, min_cost, costs) do
    if Grid.at(grid, pos) != "#" && Grid.contains?(grid, pos) && min_cost < costs[pos] do
      pos
      |> Position.neighbours()
      |> Enum.reduce(Map.put(costs, pos, min_cost), &walk(grid, &1, min_cost + 1, &2))
    else
      costs
    end
  end

  defp parse(input) do
    input
    |> lines()
    |> Enum.map(fn line ->
      {w, line} = int(line)
      h = line |> drop(",") |> int!()
      {w, h}
    end)
  end
end
