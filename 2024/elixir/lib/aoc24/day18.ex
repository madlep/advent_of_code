defmodule Aoc24.Day18 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position
  alias Aoc24.Grid.Sparse

  @spec part1(String.t(), n :: integer(), w :: integer(), h :: integer()) :: integer()
  def part1(input, n \\ 1024, w \\ 70, h \\ 70) do
    input
    |> parse()
    |> run(n, w, h)
  end

  @spec part2(String.t(), w :: integer(), h :: integer()) :: String.t()
  def part2(input, w \\ 70, h \\ 70) do
    bytes = parse(input)

    bytes
    |> find_blocking(0, length(bytes), w, h)
    |> then(fn {x, y} -> "#{x},#{y}" end)
  end

  def run(bytes, n, w, h) do
    bytes
    |> Enum.take(n)
    |> Enum.reduce(Sparse.new(w + 1, h + 1), fn pos, grid -> Grid.put(grid, pos, "#") end)
    |> walk({0, 0}, 0, %{})
    |> Map.get({w, h})
  end

  def find_blocking(bytes, i, j, _, _) when i + 1 == j, do: Enum.at(bytes, i)

  def find_blocking(bytes, i, j, w, h) do
    mid = i + div(j - i, 2)

    case run(bytes, mid, w, h) do
      nil -> find_blocking(bytes, i, mid, w, h)
      _n -> find_blocking(bytes, mid, j, w, h)
    end
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
