defmodule Aoc24.Day12 do
  import Aoc24.Parse
  alias Aoc24.Grid

  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> grid()
    |> elem(0)
    |> regions()
    |> elem(0)
    |> Enum.reduce(0, &(&2 + area(&1) * perimeter(&1)))
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp regions(plot) do
    plot
    |> Grid.positions()
    |> Enum.reduce({[], MapSet.new()}, fn pos, {regions, used} ->
      if !MapSet.member?(used, pos) do
        {region, used} = expand(MapSet.new(), pos, plot, used)
        {[region | regions], used}
      else
        {regions, used}
      end
    end)
  end

  @neighbour_dirs [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

  defp expand(region, {x, y} = pos, plot, used) do
    if !MapSet.member?(used, pos) && !MapSet.member?(region, pos) do
      region = MapSet.put(region, pos)
      used = MapSet.put(used, pos)

      @neighbour_dirs
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.reduce({region, used}, fn neighbour_pos, {region, used} ->
        plant = Grid.at(plot, pos)
        neighbour_plant = Grid.at(plot, neighbour_pos)

        if plant == neighbour_plant do
          expand(region, neighbour_pos, plot, used)
        else
          {region, used}
        end
      end)
    else
      {region, used}
    end
  end

  defp area(region) do
    MapSet.size(region)
  end

  defp perimeter(region) do
    {_checked, total} = do_perimeter(region, Enum.at(region, 0), MapSet.new(), 0)
    total
  end

  defp do_perimeter(region, {x, y} = pos, checked, total) do
    if !MapSet.member?(checked, pos) do
      checked = MapSet.put(checked, pos)

      @neighbour_dirs
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.reduce({checked, total}, fn neighbour_pos, {checked, total} ->
        if !MapSet.member?(region, neighbour_pos) do
          {checked, total + 1}
        else
          do_perimeter(region, neighbour_pos, checked, total)
        end
      end)
    else
      {checked, total}
    end
  end
end
