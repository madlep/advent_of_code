defmodule Aoc24.Day05 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.filter(&correct_order?(&1, rules))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.reject(&correct_order?(&1, rules))
    |> Enum.map(&sort(&1, rules, []))
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  defp parse(input) do
    {rules, rest} = parse_rules(input, MapSet.new())
    {rules, parse_updates(rest)}
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

  defp correct_order?([page | pages], rules) do
    if Enum.all?(pages, &correct?(page, &1, rules)) do
      correct_order?(pages, rules)
    else
      false
    end
  end

  defp correct?(page1, page2, rules), do: !MapSet.member?(rules, {page2, page1})

  defp sort([], _, acc), do: acc

  defp sort(pages, rules, acc) do
    {last_page, pages} = find_last(pages, rules, [])
    sort(pages, rules, [last_page | acc])
  end

  defp find_last([page | pages], rules, not_last) do
    if Enum.any?(pages, &(!correct?(page, &1, rules))) do
      find_last(pages, rules, [page | not_last])
    else
      {page, not_last ++ pages}
    end
  end
end
