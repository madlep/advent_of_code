defmodule Aoc24.Day10 do
  import Aoc24.Parse
  alias Aoc24.Grid.Dense

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {map, _} =
      grid(input,
        reduce_with: {fn {_, element}, acc -> {:keep, String.to_integer(element), acc} end, nil}
      )

    memo =
      for x <- Dense.xs(map),
          y <- Dense.ys(map),
          reduce: %{} do
        memo ->
          walk({x, y}, map, memo)
      end

    for x <- Dense.xs(map),
        y <- Dense.ys(map),
        reduce: 0 do
      total_score ->
        if Dense.at(map, {x, y}) == 0 do
          (memo[{x, y}] |> MapSet.size()) + total_score
        else
          total_score
        end
    end
  end

  @neighbour_dirs [
    {-1, 0},
    {0, -1},
    {1, 0},
    {0, 1}
  ]

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp walk(position, _map, memo) when is_map_key(memo, position), do: memo

  defp walk({x, y} = position, map, memo) do
    case Dense.at(map, position) do
      nil ->
        memo

      9 ->
        Map.put(memo, position, MapSet.new([position]))

      n when n in 0..8 ->
        {new_memo, result} =
          @neighbour_dirs
          |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
          |> Enum.filter(&(Dense.at(map, &1) == n + 1))
          |> Enum.reduce({memo, MapSet.new()}, fn neighbour_position, {memo_acc, result_acc} ->
            new_memo_acc = walk(neighbour_position, map, memo_acc)
            new_result_acc = MapSet.union(result_acc, new_memo_acc[neighbour_position])
            {new_memo_acc, new_result_acc}
          end)

        Map.put(new_memo, position, result)
    end
  end

  defp print(map, memo) do
    IO.inspect("")

    Enum.map(Dense.ys(map), fn y ->
      Enum.map(Dense.xs(map), fn x ->
        case memo[{x, y}] do
          nil -> "."
          mapset -> mapset |> MapSet.size() |> Integer.to_string()
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
