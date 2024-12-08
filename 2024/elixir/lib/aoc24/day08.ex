defmodule Aoc24.Day08 do
  import Aoc24.Parse
  alias Aoc24.Grid.Sparse

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {grid, freq_positions} = parse(input)

    freq_positions
    |> Enum.flat_map(fn {_freq, positions} ->
      positions
      |> pairs()
      |> Enum.map(fn {p1, p2} ->
        delta = sub_positions(p1, p2)
        add_positions(p1, delta)
      end)
    end)
    |> Enum.uniq()
    |> Enum.filter(&Sparse.contains?(grid, &1))
    |> Enum.count()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp pairs(xs) do
    xs
    |> Enum.with_index()
    |> Enum.flat_map(fn {x, i} ->
      {_, xs_no_x} = List.pop_at(xs, i)
      xs_no_x |> Enum.map(&{x, &1})
    end)
  end

  defp sub_positions({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}

  defp add_positions({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp parse(input) do
    freq_reducer = fn {pos, freq}, acc ->
      {:keep, freq, Map.update(acc, freq, [pos], fn poss -> [pos | poss] end)}
    end

    sparse_grid(input, reduce_with: {freq_reducer, %{}})
  end
end
