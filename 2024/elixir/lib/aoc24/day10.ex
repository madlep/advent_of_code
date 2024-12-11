defmodule Aoc24.Day10 do
  import Aoc24.Parse
  alias Aoc24.Grid.Dense

  @spec part1(String.t()) :: integer()
  def part1(input) do
    run(input, MapSet.new(), &MapSet.new([&1]), &MapSet.union/2, &MapSet.size/1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    run(input, 0, fn _ -> 1 end, &+/2, & &1)
  end

  defp run(input, empty, init, append, score) do
    {map, _} =
      grid(input,
        reduce_with: {fn {_, element}, acc -> {:keep, String.to_integer(element), acc} end, nil}
      )

    {_, total_score} =
      for x <- Dense.xs(map),
          y <- Dense.ys(map),
          reduce: {%{}, 0} do
        {memo, total_score} ->
          if Dense.at(map, {x, y}) == 0 do
            memo = walk(memo, {x, y}, map, empty, init, append)
            {memo, total_score + score.(memo[{x, y}])}
          else
            {memo, total_score}
          end
      end

    total_score
  end

  @neighbour_dirs [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

  defp walk(memo, pos, _map, _empty, _init, _append) when is_map_key(memo, pos), do: memo

  defp walk(memo, {x, y} = pos, map, empty, init, append) do
    case Dense.at(map, pos) do
      nil ->
        memo

      9 ->
        Map.put(memo, pos, init.(pos))

      n when n in 0..8 ->
        @neighbour_dirs
        |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
        |> Enum.filter(&(Dense.at(map, &1) == n + 1))
        |> Enum.reduce(Map.put(memo, pos, empty), fn neighbour_pos, memo ->
          memo = walk(memo, neighbour_pos, map, empty, init, append)
          Map.update!(memo, pos, fn old_walk -> append.(old_walk, memo[neighbour_pos]) end)
        end)
    end
  end
end
