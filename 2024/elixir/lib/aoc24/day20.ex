defmodule Aoc24.Day20 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t(), n :: integer()) :: integer()
  def part1(input, min_saving \\ 100), do: run(input, min_saving, 2)

  @spec part2(String.t(), n :: integer()) :: integer()
  def part2(input, min_saving \\ 100), do: run(input, min_saving, 20)

  defp run(input, min_saving, max_shortcut) do
    {grid, start} = parse(input)
    track_costs = build_track(grid, start, 0, %{})

    Enum.sum_by(track_costs, fn {start_pos, start_cost} ->
      start_pos
      |> Position.within_manhattan(max_shortcut)
      |> Enum.sum_by(fn finish_pos ->
        with finish_cost when finish_cost != nil <- track_costs[finish_pos],
             shortcut_cost = Position.manhattan_distance(start_pos, finish_pos),
             true <- finish_cost - start_cost - shortcut_cost >= min_saving do
          1
        else
          _ -> 0
        end
      end)
    end)
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

  defp parse(input), do: sparse_grid(input, reduce: {&grid_reducer/2, nil})

  defp grid_reducer({start, "S"}, nil), do: {:discard, start}
  defp grid_reducer({_ending, "E"}, acc), do: {:discard, acc}
  defp grid_reducer({_pos, "#"}, acc), do: {:keep, "#", acc}
end
