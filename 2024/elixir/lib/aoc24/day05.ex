defmodule Aoc24.Day05 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {rules, rest} = parse_rules(input, MapSet.new())

    rest
    |> parse_updates()
    |> Enum.filter(&correct_order?(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse_rules(<<"\n", rest::binary>>, rules), do: {rules, rest}

  defp parse_rules(input, rules) do
    {n1, rest} = Integer.parse(input)
    <<"|", rest::binary>> = rest
    {n2, rest} = Integer.parse(rest)
    <<"\n", rest::binary>> = rest
    parse_rules(rest, MapSet.put(rules, {n1, n2}))
  end

  defp parse_updates(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp correct_order?([_], _rules), do: true

  defp correct_order?([h | t], rules) do
    if Enum.all?(t, &(!MapSet.member?(rules, {&1, h}))) do
      correct_order?(t, rules)
    else
      false
    end
  end
end
