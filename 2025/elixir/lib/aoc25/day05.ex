defmodule Aoc25.Day05 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {fresh_ranges, ingredient_ids} = parse(input)
    Enum.count(ingredient_ids, fn id -> Enum.any?(fresh_ranges, &(id in &1)) end)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {fresh_ranges, _ingredient_ids} = parse(input)

    fresh_ranges
    |> Enum.reduce([], &merge_all_ranges/2)
    |> Enum.sum_by(&Range.size/1)
  end

  defp merge_all_ranges(new_range, ranges, acc \\ [])

  defp merge_all_ranges(new_range, [], acc), do: Enum.reverse([new_range | acc])

  defp merge_all_ranges(new_range, [range | ranges], acc) do
    case merge_ranges(new_range, range) do
      {:merged, merged_range} -> merge_all_ranges(merged_range, ranges, acc)
      :no_merge -> merge_all_ranges(new_range, ranges, [range | acc])
    end
  end

  def merge_ranges(first1..last1//1 = r1, first2..last2//1 = r2) do
    cond do
      # touching 1 then 2 - combine
      last1 == first2 - 1 ->
        {:merged, first1..last2}

      # touching 2 then 1 - combine
      last2 == first1 - 1 ->
        {:merged, first2..last1}

      # any overlap -- combine
      first1 in r2 || last1 in r2 || first2 in r1 || last2 in r1 ->
        {:merged, min(first1, first2)..max(last1, last2)}

      # no touching/overlap - separate
      true ->
        :no_merge
    end
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
