defmodule Aoc24.Days.Day02 do
  @spec part1(Enumerable.t(String.t())) :: integer()
  def part1(input) do
    input
    |> Enum.count(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> safe?()
    end)
  end

  def safe?(reports), do: safe?(reports, tolerated(reports))

  def tolerated([r1, r2 | _]) when r1 < r2, do: 1..3
  def tolerated(_), do: -3..-1

  def safe?([_r], _), do: true

  def safe?([r1 | [r2 | _] = rest], tol) do
    if (r2 - r1) in tol do
      safe?(rest, tol)
    else
      false
    end
  end

  @spec part2(Enumerable.t(String.t())) :: integer()
  def part2(input) do
    input
    |> Enum.count(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> take_one_permutations()
      |> Enum.any?(&safe?/1)
    end)
  end

  def take_one_permutations(reports) do
    take_one_permutations(reports, [], [])
  end

  def take_one_permutations([], _, acc), do: Enum.reverse(acc)

  def take_one_permutations([r | rest], buffer, acc) do
    take_one_permutations(rest, [r | buffer], [Enum.reverse(buffer) ++ rest | acc])
  end
end
