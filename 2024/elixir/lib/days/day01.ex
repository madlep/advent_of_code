defmodule Aoc24.Days.Day01 do
  def part1(input) do
    input
    |> parse()
    |> then(fn {ns1, ns2} -> [Enum.sort(ns1), Enum.sort(ns2)] end)
    |> Enum.zip_with(fn [n1, n2] -> abs(n2 - n1) end)
    |> Enum.sum()
  end

  def part2(input) do
    {ns1, ns2} = parse(input)
    ns2_counts = Enum.reduce(ns2, %{}, fn n, counts -> Map.update(counts, n, 1, &(&1 + 1)) end)

    ns1
    |> Enum.map(fn n1 -> n1 * Map.get(ns2_counts, n1, 0) end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [n1, n2] = line |> String.split(~r/\s+/)
      {String.to_integer(n1), String.to_integer(n2)}
    end)
    |> Enum.reduce({[], []}, fn {n1, n2}, {ns1, ns2} -> {[n1 | ns1], [n2 | ns2]} end)
  end
end
