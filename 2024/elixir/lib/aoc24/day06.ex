defmodule Aoc24.Day06 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {guard, {grid, w, h}} = parse(input)

    guard
    |> Stream.iterate(&move(&1, grid))
    |> Stream.take_while(fn {{x, y}, _dir} -> x in 0..(w - 1) && y in 0..(h - 1) end)
    |> Enum.reduce(MapSet.new(), fn {pos, _dir}, acc -> MapSet.put(acc, pos) end)
    |> Enum.count()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  @left {-1, 0}
  @up {0, -1}
  @right {1, 0}
  @down {0, 1}

  defp parse(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    h = length(lines)
    w = lines |> hd() |> byte_size()

    {guard, grid} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({nil, MapSet.new()}, fn {line, y}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn
          {"^", x}, {_, grid} -> {{{x, y}, @up}, grid}
          {"#", x}, {guard, grid} -> {guard, MapSet.put(grid, {x, y})}
          {_, _}, acc -> acc
        end)
      end)

    {guard, {grid, w, h}}
  end

  defp move({{x, y} = pos, {dx, dy} = dir}, grid) do
    new_pos = {x + dx, y + dy}

    if !MapSet.member?(grid, new_pos) do
      {new_pos, dir}
    else
      move({pos, turn(dir)}, grid)
    end
  end

  defp turn(@left), do: @up
  defp turn(@up), do: @right
  defp turn(@right), do: @down
  defp turn(@down), do: @left
end
