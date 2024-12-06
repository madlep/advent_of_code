defmodule Aoc24.Day01 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> then(fn {ns1, ns2} -> [Enum.sort(ns1), Enum.sort(ns2)] end)
    |> Enum.zip_reduce(0, fn [n1, n2], sum -> sum + abs(n2 - n1) end)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {ns1, ns2} = parse(input)
    ns2_counts = Enum.frequencies(ns2)
    Enum.reduce(ns1, 0, fn n, sum -> sum + n * (ns2_counts[n] || 0) end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [n1, n2] = line |> String.split(~r/\s+/, trim: true)
      {String.to_integer(n1), String.to_integer(n2)}
    end)
    |> Enum.unzip()
  end
end
