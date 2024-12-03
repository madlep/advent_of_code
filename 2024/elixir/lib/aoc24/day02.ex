defmodule Aoc24.Day02 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.count(fn line ->
      line
      |> parse_report()
      |> safe?()
    end)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.count(fn line ->
      line
      |> parse_report()
      |> tolerated_permutations()
      |> Enum.any?(&safe?/1)
    end)
  end

  defp parse_report(line), do: line |> String.split() |> Enum.map(&String.to_integer/1)

  defp tolerated([r1, r2 | _]), do: if(r1 < r2, do: 1..3, else: -3..-1)

  defp safe?(reports), do: safe?(reports, tolerated(reports))
  defp safe?([_r], _), do: true
  defp safe?([r1 | [r2 | _] = rest], t), do: if((r2 - r1) in t, do: safe?(rest, t), else: false)

  defp tolerated_permutations(reports), do: perms(reports, [], [])

  defp perms([], _, acc), do: Enum.reverse(acc)
  defp perms([r | rs], rs2, acc), do: perms(rs, [r | rs2], [Enum.reverse(rs2) ++ rs | acc])
end
