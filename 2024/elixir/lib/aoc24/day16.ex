defmodule Aoc24.Day16 do
  import Aoc24.Parse
  import Aoc24.Grid.Position
  alias Aoc24.Grid

  @east {1, 0}

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {g, {from, to}} = parse(input)

    {_, min, _} =
      walk({from, @east, 0, [from]}, {%{}, 200_000, MapSet.new()}, {to, g, &>/2})

    min
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {g, {from, to}} = parse(input)

    {costs, min, _} =
      walk({from, @east, 0, [from]}, {%{}, 200_000, MapSet.new()}, {to, g, &>/2})

    {_, _, best} =
      walk({from, @east, 0, [from]}, {costs, min + 1, MapSet.new()}, {to, g, &>=/2})

    MapSet.size(best)
  end

  defp walk({_, _, cost, _}, {_, min, _} = acc, _) when cost > min,
    do: acc

  defp walk({p, _, cost, path}, {costs, min, _best}, {to, _, _}) when p == to and cost < min,
    do: {costs, cost, MapSet.new([to | path])}

  defp walk({p, _, cost, path}, {costs, min, best}, {to, _, _}) when p == to and cost == min,
    do: {costs, min, best |> MapSet.union(MapSet.new(path))}

  defp walk({p, dir, cost, path}, {costs, min, best} = acc, {_, g, costs_check} = config) do
    with true <- costs_check.(costs[{p, dir}], cost),
         true <- Grid.at!(g, p) != "#" do
      [
        {p, rotate_right(dir), cost + 1000, [p | path]},
        {p, rotate_left(dir), cost + 1000, [p | path]},
        {move(p, dir), dir, cost + 1, [p | path]}
      ]
      |> Enum.reduce({Map.put(costs, {p, dir}, cost), min, best}, &walk(&1, &2, config))
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
