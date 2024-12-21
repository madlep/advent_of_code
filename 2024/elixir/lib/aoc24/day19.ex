defmodule Aoc24.Day19 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input), do: input |> run() |> Enum.filter(&(&1 > 0)) |> Enum.count()

  @spec part2(String.t()) :: integer()
  def part2(input), do: input |> run() |> Enum.sum()

  defp run(input) do
    {towels, patterns} = parse(input)
    Enum.map(patterns, &(count_patterns(&1, towels, %{}) |> elem(0)))
  end

  defp count_patterns("", _towels, memo), do: {1, memo}

  defp count_patterns(pattern, towels, memo) do
    0..String.length(pattern)
    |> Enum.reduce({0, memo}, fn n, {count, memo} = acc ->
      {maybe_towel, rest_pattern} = String.split_at(pattern, n)

      if MapSet.member?(towels, maybe_towel) do
        case memo[rest_pattern] do
          nil ->
            {child_count, memo} = count_patterns(rest_pattern, towels, memo)
            {count + child_count, Map.put(memo, rest_pattern, child_count)}

          child_count ->
            {count + child_count, memo}
        end
      else
        acc
      end
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
