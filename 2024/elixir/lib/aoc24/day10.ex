defmodule Aoc24.Day10 do
  import Aoc24.Parse
  alias Aoc24.Grid.Dense

  @spec part1(String.t()) :: integer()
  def part1(input) do
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
            memo = peaks(memo, {x, y}, map)
            {memo, total_score + MapSet.size(memo[{x, y}])}
          else
            {memo, total_score}
          end
      end

    total_score
  end

  @neighbour_dirs [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp peaks(memo, pos, _map) when is_map_key(memo, pos), do: memo

  defp peaks(memo, {x, y} = pos, map) do
    case Dense.at(map, pos) do
      nil ->
        memo

      9 ->
        Map.put(memo, pos, MapSet.new([pos]))

      n when n in 0..8 ->
        @neighbour_dirs
        |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
        |> Enum.filter(&(Dense.at(map, &1) == n + 1))
        |> Enum.reduce(Map.put(memo, pos, MapSet.new()), fn neighbour_pos, memo ->
          memo = peaks(memo, neighbour_pos, map)
          Map.update!(memo, pos, fn old_memo -> MapSet.union(old_memo, memo[neighbour_pos]) end)
        end)
    end
  end
end
