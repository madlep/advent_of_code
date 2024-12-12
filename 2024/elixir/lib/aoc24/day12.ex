defmodule Aoc24.Day12 do
  import Aoc24.Parse
  alias Aoc24.Grid
  alias Aoc24.Grid.Position

  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> regions()
    |> Enum.map(&(area(&1) * perimeter(&1)))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> regions()
    |> Enum.map(&(area(&1) * edges(&1)))
    |> Enum.sum()
  end

  defp regions(input) do
    plot = input |> grid() |> elem(0)

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
    |> elem(0)
  end

  defp expand(region, pos, plot, used) do
    if !MapSet.member?(used, pos) && !MapSet.member?(region, pos) do
      region = MapSet.put(region, pos)
      used = MapSet.put(used, pos)

      pos
      |> Position.neighbours()
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

  defp area(region), do: MapSet.size(region)

  defp perimeter(region) do
    region
    |> edge_parts()
    |> MapSet.size()
  end

  defp edges(region) do
    region
    |> edge_parts()
    |> combine_edge_parts()
  end

  defp edge_parts(region) do
    edge_parts(region, Enum.at(region, 0), MapSet.new(), MapSet.new()) |> elem(1)
  end

  defp edge_parts(region, pos, checked, parts) do
    if !MapSet.member?(checked, pos) do
      checked = MapSet.put(checked, pos)

      pos
      |> Position.neighbours()
      |> Enum.reduce({checked, parts}, fn neighbour_pos, {checked, parts} ->
        if !MapSet.member?(region, neighbour_pos) do
          {checked, MapSet.put(parts, {pos, neighbour_pos})}
        else
          edge_parts(region, neighbour_pos, checked, parts)
        end
      end)
    else
      {checked, parts}
    end
  end

  defp combine_edge_parts(parts), do: combine_edge_parts(parts, Enum.at(parts, 0), 0)

  defp combine_edge_parts(_parts, nil, edge_count), do: edge_count

  defp combine_edge_parts(parts, part, edge_count) do
    parts =
      parts
      |> MapSet.delete(part)
      |> extend_edge(part, &Position.rotate_left/1)
      |> extend_edge(part, &Position.rotate_right/1)

    combine_edge_parts(parts, Enum.at(parts, 0), edge_count + 1)
  end

  defp extend_edge(parts, part, rot) do
    maybe_extended_part = shift(part, rot)

    if MapSet.member?(parts, maybe_extended_part) do
      parts
      |> MapSet.delete(maybe_extended_part)
      |> extend_edge(maybe_extended_part, rot)
    else
      parts
    end
  end

  defp shift({plant, neighbour}, rot) do
    delta =
      plant
      |> Position.dir(neighbour)
      |> rot.()

    {Position.move(plant, delta), Position.move(neighbour, delta)}
  end
end
