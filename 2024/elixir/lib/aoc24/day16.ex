defmodule Aoc24.Day16 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {g, {from, to}} = parse(input)
    dir = {1, 0}

    walk(from, dir, to, g, %{}, 0, 200_000, [from], MapSet.new(), &>/2)
    |> elem(1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {g, {from, to}} = parse(input)
    dir = {1, 0}

    {costs, min, _} =
      walk(from, dir, to, g, %{}, 0, 200_000, [from], MapSet.new(), &>/2)

    {_, _, best} =
      walk(from, dir, to, g, costs, 0, min + 1, [from], MapSet.new(), &>=/2)

    MapSet.size(best)
  end

  defp walk(_, _, _, _, costs, cost, min, _path, best, _) when cost > min, do: {costs, min, best}

  defp walk(p, _, to, _, costs, cost, min, path, _, _) when p == to and cost < min,
    do: {costs, cost, MapSet.new([to | path])}

  defp walk(p, _, to, _, costs, cost, min, path, best, _) when p == to and cost == min,
    do: {costs, min, best |> MapSet.union(MapSet.new(path))}

  defp walk(p, dir, to, g, costs, cost, min, path, best, costs_check) do
    with true <- costs_check.(costs[{p, dir}], cost),
         costs <- Map.put(costs, {p, dir}, cost),
         true <- Grid.at!(g, p) != "#" do
      path = [p | path]

      [
        {p, Position.rotate_right(dir), cost + 1000},
        {p, Position.rotate_left(dir), cost + 1000},
        {Position.move(p, dir), dir, cost + 1}
      ]
      |> Enum.reduce({costs, min, best}, fn {p, d, c}, {costs, min, best} ->
        walk(p, d, to, g, costs, c, min, path, best, costs_check)
      end)
    else
      _ -> {costs, min, best}
    end
  end

  defp parse(input) do
    input
    |> sparse_grid(reduce: {&parse_reducer/2, {nil, nil}})
  end

  defp parse_reducer({from, "S"}, {nil, to}), do: {:discard, {from, to}}
  defp parse_reducer({to, "E"}, {from, nil}), do: {:discard, {from, to}}
  defp parse_reducer({_, "#"}, acc), do: {:keep, "#", acc}
end
