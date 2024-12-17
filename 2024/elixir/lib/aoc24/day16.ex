defmodule Aoc24.Day16 do
  import Aoc24.Parse
  alias Aoc24.Grid
  import Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, {start_pos, end_pos}} = parse(input)
    dir = {1, 0}

    {_, mincost} =
      shortest(start_pos, dir, end_pos, grid, %{}, 0, nil, [start_pos])

    mincost
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {grid, {start_pos, end_pos}} = parse(input)
    dir = {1, 0}

    {_, _, best_paths} =
      shortest(start_pos, dir, end_pos, grid, %{}, 0, nil, [start_pos])

    # best_paths
    # |> Enum.reduce(grid, fn p, grid -> Grid.put(grid, p, "O") end)
    # |> Grid.print()
    # |> IO.puts()

    MapSet.size(best_paths)
  end

  defp shortest(_, _, _, _, visited, cost, mincost, _path) when cost > mincost,
    do: {visited, mincost}

  defp shortest(pos, _, target, _, visited, cost, mincost, path)
       when pos == target and cost < mincost do
    IO.inspect("new best mincost, cost=#{cost} pathsize=#{length(path)}")
    {visited, cost}
  end

  defp shortest(pos, _, target, _, visited, cost, mincost, _path)
       when pos == target and cost == mincost do
    {visited, mincost}
  end

  defp shortest(pos, dir, target, g, visited, cost, mincost, path) do
    if visited[{pos, dir}] > cost do
      visited = Map.put(visited, {pos, dir}, cost)

      if Grid.at!(g, pos) != "#" do
        path = [pos | path]

        [
          {pos, rotate_right(dir), cost + 1000},
          {pos, rotate_left(dir), cost + 1000},
          {move(pos, dir), dir, cost + 1}
        ]
        |> Enum.reduce({visited, mincost}, fn {p, d, c}, {visited, mincost} ->
          shortest(p, d, target, g, visited, c, mincost, path)
        end)
      else
        {visited, mincost}
      end
    else
      {visited, mincost}
    end
  end

  defp parse(input) do
    input
    |> sparse_grid(reduce: {&parse_reducer/2, {nil, nil}})
  end

  defp parse_reducer({start_pos, "S"}, {nil, end_pos}), do: {:discard, {start_pos, end_pos}}
  defp parse_reducer({end_pos, "E"}, {start_pos, nil}), do: {:discard, {start_pos, end_pos}}
  defp parse_reducer({_pos, "#"}, acc), do: {:keep, "#", acc}

  # defp dir_s({-1, 0}), do: "<"
  # defp dir_s({0, -1}), do: "^"
  # defp dir_s({1, 0}), do: ">"
  # defp dir_s({0, 1}), do: "v"

  # defp pry(grid, pos, dir, visited, cost, mincost, path) do
  #   grid_to_print =
  #     path
  #     |> Enum.reverse()
  #     |> Enum.reduce(grid, fn {pos, dir}, g -> g |> Grid.put(pos, dir_s(dir)) end)
  #     |> Grid.put(pos, "@")

  #   IO.puts("\n" <> Grid.print(grid_to_print) <> "\nDIR: #{dir_s(dir)}\nCOST: #{cost}")
  #   require IEx
  #   IEx.pry()
  # end
end
