defmodule Aoc24.Day06 do
  import Aoc24.Parse

  alias Aoc24.Grid

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {guard, grid} = parse(input)

    guard
    |> route(grid)
    |> Stream.uniq_by(fn {pos, _dir} -> pos end)
    |> Enum.count()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {guard, grid} = parse(input)

    guard
    |> route(grid)
    |> Stream.uniq_by(fn {pos, _dir} -> pos end)
    |> Stream.filter(fn {pos, _dir} ->
      guard |> route(Grid.put(grid, pos, "#")) |> loop?()
    end)
    |> Enum.count()
  end

  defp route(guard, grid) do
    guard
    |> Stream.iterate(&move(&1, grid))
    |> Stream.take_while(fn {pos, _dir} -> Grid.contains?(grid, pos) end)
  end

  defp loop?(route) do
    route
    |> Enum.reduce_while(MapSet.new(), fn guard, positions ->
      if MapSet.member?(positions, guard) do
        {:halt, :loop}
      else
        {:cont, MapSet.put(positions, guard)}
      end
    end) == :loop
  end

  defp move({{x, y} = pos, {dx, dy} = dir}, grid) do
    new_pos = {x + dx, y + dy}

    if Grid.at(grid, new_pos) != "#" do
      {new_pos, dir}
    else
      move({pos, turn(dir)}, grid)
    end
  end

  @left {-1, 0}
  @up {0, -1}
  @right {1, 0}
  @down {0, 1}

  defp turn(@left), do: @up
  defp turn(@up), do: @right
  defp turn(@right), do: @down
  defp turn(@down), do: @left

  defp parse(input) do
    guard_reducer = fn
      {position, "^"}, _acc -> {:discard, {position, @up}}
      {_position, element}, acc -> {:keep, element, acc}
    end

    {grid, guard} = sparse_grid(input, reduce: {guard_reducer, nil})

    {guard, grid}
  end
end
