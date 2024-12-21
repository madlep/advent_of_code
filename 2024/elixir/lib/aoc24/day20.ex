defmodule Aoc24.Day20 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t(), n :: integer()) :: integer()
  def part1(input, n \\ 100) do
    {grid, {start, _ending}} = parse(input)
    track_costs = build_track(grid, start, 0, %{})

    track_costs
    |> Enum.flat_map(fn {pos, cost} -> shortcuts(pos, cost, track_costs, grid, 2) end)
    |> Enum.filter(&(&1 >= n))
    |> Enum.count()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp build_track(grid, pos, cost, positions) do
    if Grid.at(grid, pos) != "#" && positions[pos] == nil do
      positions = Map.put(positions, pos, cost)

      pos
      |> Position.neighbours()
      |> Enum.reduce(positions, &build_track(grid, &1, cost + 1, &2))
    else
      positions
    end
  end

  defp shortcuts(pos, start_cost, track_costs, grid, 0) do
    if Grid.at(grid, pos) != "#" do
      final_cost = track_costs[pos]

      if(final_cost < start_cost) do
        [start_cost - final_cost]
      else
        []
      end
    else
      []
    end
  end

  defp shortcuts(pos, start_cost, track_costs, grid, limit) do
    pos
    |> Position.neighbours()
    |> Enum.flat_map(&shortcuts(&1, start_cost - 1, track_costs, grid, limit - 1))
  end

  defp parse(input) do
    sparse_grid(input, reduce: {&grid_reducer/2, {nil, nil}})
  end

  defp grid_reducer({start, "S"}, {nil, ending}), do: {:discard, {start, ending}}
  defp grid_reducer({ending, "E"}, {start, nil}), do: {:discard, {start, ending}}
  defp grid_reducer({_pos, "#"}, acc), do: {:keep, "#", acc}
end
