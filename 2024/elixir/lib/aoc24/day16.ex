defmodule Aoc24.Day16 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {g, {from, to}} = parse(input)

    walk(from, {1, 0}, to, g, 0, [from], &>/2, {%{}, 200_000, MapSet.new()})
    |> elem(1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {g, {from, to}} = parse(input)

    {costs, min, _} =
      walk(from, {1, 0}, to, g, 0, [from], &>/2, {%{}, 200_000, MapSet.new()})

    {_, _, best} =
      walk(from, {1, 0}, to, g, 0, [from], &>=/2, {costs, min + 1, MapSet.new()})

    MapSet.size(best)
  end

  defp walk(_, _, _, _, cost, _path, _, {_, min, _} = acc) when cost > min,
    do: acc

  defp walk(p, _, to, _, cost, path, _, {costs, min, _best}) when p == to and cost < min,
    do: {costs, cost, MapSet.new([to | path])}

  defp walk(p, _, to, _, cost, path, _, {costs, min, best}) when p == to and cost == min,
    do: {costs, min, best |> MapSet.union(MapSet.new(path))}

  defp walk(p, dir, to, g, cost, path, costs_check, {costs, min, best} = acc) do
    with true <- costs_check.(costs[{p, dir}], cost),
         costs <- Map.put(costs, {p, dir}, cost),
         true <- Grid.at!(g, p) != "#" do
      path = [p | path]

      [
        {p, Position.rotate_right(dir), cost + 1000},
        {p, Position.rotate_left(dir), cost + 1000},
        {Position.move(p, dir), dir, cost + 1}
      ]
      |> Enum.reduce({costs, min, best}, fn {p, d, c}, acc ->
        walk(p, d, to, g, c, path, costs_check, acc)
      end)
    else
      _ -> acc
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
