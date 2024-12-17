defmodule Aoc24.Day16 do
  import Aoc24.Parse
  alias Aoc24.Grid
  import Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, {start_pos, end_pos}} = parse(input)
    dir = {1, 0}

    {_, mincost, _} =
      shortest(start_pos, dir, end_pos, grid, %{}, 0, 200_000, [start_pos], MapSet.new(), &>/2)

    mincost
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {grid, {start_pos, end_pos}} = parse(input)
    dir = {1, 0}

    {visited, mincost, _} =
      shortest(start_pos, dir, end_pos, grid, %{}, 0, 200_000, [start_pos], MapSet.new(), &>/2)

    {_, _, best} =
      shortest(
        start_pos,
        dir,
        end_pos,
        grid,
        visited,
        0,
        mincost + 1,
        [start_pos],
        MapSet.new(),
        &>=/2
      )

    MapSet.size(best)
  end

  defp shortest(_, _, _, _, visited, cost, mincost, _path, best, _) when cost > mincost,
    do: {visited, mincost, best}

  defp shortest(pos, _, target, _, visited, cost, mincost, path, _best, _)
       when pos == target and cost < mincost do
    {visited, cost, MapSet.new([target | path])}
  end

  defp shortest(pos, _, target, _, visited, cost, mincost, path, best, _)
       when pos == target and cost == mincost do
    {visited, mincost, best |> MapSet.union(MapSet.new(path))}
  end

  defp shortest(pos, dir, target, g, visited, cost, mincost, path, best, visited_check) do
    with true <- visited_check.(visited[{pos, dir}], cost),
         visited <- Map.put(visited, {pos, dir}, cost),
         true <- Grid.at!(g, pos) != "#" do
      path = [pos | path]

      [
        {pos, rotate_right(dir), cost + 1000},
        {pos, rotate_left(dir), cost + 1000},
        {move(pos, dir), dir, cost + 1}
      ]
      |> Enum.reduce({visited, mincost, best}, fn {p, d, c}, {visited, mincost, best} ->
        shortest(p, d, target, g, visited, c, mincost, path, best, visited_check)
      end)
    else
      _ -> {visited, mincost, best}
    end
  end

  defp parse(input) do
    input
    |> sparse_grid(reduce: {&parse_reducer/2, {nil, nil}})
  end

  defp parse_reducer({start_pos, "S"}, {nil, end_pos}), do: {:discard, {start_pos, end_pos}}
  defp parse_reducer({end_pos, "E"}, {start_pos, nil}), do: {:discard, {start_pos, end_pos}}
  defp parse_reducer({_pos, "#"}, acc), do: {:keep, "#", acc}
end
