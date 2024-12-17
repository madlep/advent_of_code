defmodule Aoc24.Day16 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, {start_pos, end_pos}} = parse(input)
    dir = {1, 0}
    {_, mincost} = shortest(start_pos, dir, end_pos, grid)
    mincost
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp shortest(pos, dir, target, grid, visited \\ %{}, cost \\ 0, mincost \\ nil, path \\ [])

  defp shortest(_, _, _, _, visited, cost, mincost, _path) when cost > mincost do
    {visited, mincost}
  end

  defp shortest(pos, _, target, _, visited, cost, mincost, _path) when pos == target do
    IO.inspect("pos == target, cost=#{cost} mincost=#{min(cost, mincost)}")
    {visited, min(cost, mincost)}
  end

  defp shortest(pos, dir, target, grid, visited, cost, mincost, path) do
    path = [{pos, dir} | path]
    # pry(grid, pos, dir, visited, cost, mincost, path)

    if visited[{pos, dir}] > cost do
      visited = Map.put(visited, {pos, dir}, cost)

      if Grid.at!(grid, pos) != "#" do
        [
          {pos, Position.rotate_left(dir), 1000},
          {pos, Position.rotate_right(dir), 1000},
          {Position.move(pos, dir), dir, 1}
        ]
        |> Enum.reduce({visited, mincost}, fn {pos, dir, dcost}, {visited, mincost} ->
          {visited, maybe_mincost} =
            shortest(pos, dir, target, grid, visited, cost + dcost, mincost, path)

          {visited, min(mincost, maybe_mincost)}
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

  defp dir_s({-1, 0}), do: "<"
  defp dir_s({0, -1}), do: "^"
  defp dir_s({1, 0}), do: ">"
  defp dir_s({0, 1}), do: "v"

  defp pry(grid, pos, dir, visited, cost, mincost, path) do
    grid_to_print =
      path
      |> Enum.reverse()
      |> Enum.reduce(grid, fn {pos, dir}, g -> g |> Grid.put(pos, dir_s(dir)) end)
      |> Grid.put(pos, "@")

    IO.puts("\n" <> Grid.print(grid_to_print) <> "\nDIR: #{dir_s(dir)}\nCOST: #{cost}")
    require IEx
    IEx.pry()
  end
end
