defmodule Aoc25.Day05 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {fresh_ranges, ingredient_ids} = parse(input)
    Enum.count(ingredient_ids, fn id -> Enum.any?(fresh_ranges, &(id in &1)) end)
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    {fresh_ranges, input} = parse_fresh_ranges(input)
    {ingredient_ids, <<>>} = parse_ingredient_ids(input)
    {fresh_ranges, ingredient_ids}
  end

  defp parse_fresh_ranges(input, acc \\ [])
  defp parse_fresh_ranges("\n" <> rest, acc), do: {Enum.reverse(acc), rest}

  defp parse_fresh_ranges(input, acc) do
    {from, input} = Integer.parse(input)
    "-" <> input = input
    {to, input} = Integer.parse(input)
    "\n" <> input = input

    parse_fresh_ranges(input, [from..to//1 | acc])
  end

  defp parse_ingredient_ids(input, acc \\ [])
  defp parse_ingredient_ids(<<>>, acc), do: {Enum.reverse(acc), <<>>}

  defp parse_ingredient_ids(input, acc) do
    {ingredient_id, input} = Integer.parse(input)
    "\n" <> input = input
    parse_ingredient_ids(input, [ingredient_id | acc])
  end
end
