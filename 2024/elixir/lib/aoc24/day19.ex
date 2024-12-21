defmodule Aoc24.Day19 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input) do
    {towels, patterns} = parse(input)

    patterns
    |> Enum.filter(&possible_pattern?(&1, towels))
    |> Enum.count()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp possible_pattern?("", _towels), do: true

  defp possible_pattern?(pattern, towels) do
    Enum.any?(0..String.length(pattern), fn n ->
      with {maybe_towel, rest_pattern} = String.split_at(pattern, n),
           true <- MapSet.member?(towels, maybe_towel),
           do: possible_pattern?(rest_pattern, towels)
    end)
  end

  defp parse(input) do
    {towels, input} = parse_towels(input)
    {MapSet.new(towels), input |> lines()}
  end

  defp parse_towels(input) do
    [towels_s, input] = String.split(input, "\n\n", trim: true, parts: 2)
    {towels_s |> String.split(", "), input}
  end
end
