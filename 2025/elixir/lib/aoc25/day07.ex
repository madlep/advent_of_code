defmodule Aoc25.Day07 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> propagate()
    |> elem(1)
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn
        {"S", i}, layer -> Map.put(layer, i, :start)
        {"^", i}, layer -> Map.put(layer, i, :splitter)
        {_, _i}, layer -> layer
      end)
    end)
  end

  defp propagate(layers) do
    [start | layers] = layers

    [{start_id, :start}] = start |> Map.to_list()

    layers
    |> Enum.reduce({%{start_id => :beam}, 0}, fn layer, {state, splits} ->
      layer
      |> Enum.reduce({state, splits}, fn {splitter_id, :splitter}, {new_state, new_splits} ->
        if Map.has_key?(new_state, splitter_id) do
          {new_state
           |> Map.delete(splitter_id)
           |> Map.put_new(splitter_id - 1, :beam)
           |> Map.put_new(splitter_id + 1, :beam), new_splits + 1}
        else
          {new_state, new_splits}
        end
      end)
    end)
  end
end
