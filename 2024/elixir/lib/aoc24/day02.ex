defmodule Aoc24.Day02 do
  import Aoc24.Parse

  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse()
    |> Enum.count(&safe?/1)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse()
    |> Enum.count(fn report -> report |> tolerated_permutations() |> Enum.any?(&safe?/1) end)
  end

  defp tolerated([r1, r2 | _]), do: if(r1 < r2, do: 1..3, else: -3..-1)

  defp safe?(reports), do: safe?(reports, tolerated(reports))
  defp safe?([_r], _), do: true
  defp safe?([r1 | [r2 | _] = rest], t), do: if((r2 - r1) in t, do: safe?(rest, t), else: false)

  defp tolerated_permutations(reports), do: perms(reports, [], [])

  defp perms([], _, acc), do: Enum.reverse(acc)
  defp perms([r | rs], rs2, acc), do: perms(rs, [r | rs2], [Enum.reverse(rs2) ++ rs | acc])

  defp parse(input) do
    input
    |> lines()
    |> Enum.map(&ints/1)
  end
end
