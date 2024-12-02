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

  @spec part2(Enumerable.t(String.t())) :: integer()
  def part2(input) do
    input
    |> Enum.count(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> take_one_perms()
      |> Enum.any?(&safe?/1)
    end)
  end

  defp tolerated([r1, r2 | _]), do: if(r1 < r2, do: 1..3, else: -3..-1)

  defp safe?(reports), do: safe?(reports, tolerated(reports))
  defp safe?([_r], _), do: true
  defp safe?([r1 | [r2 | _] = rest], t), do: if((r2 - r1) in t, do: safe?(rest, t), else: false)

  defp take_one_perms(reports), do: t1perms(reports, [], [])

  defp t1perms([], _, acc), do: Enum.reverse(acc)
  defp t1perms([r | rs], rs2, acc), do: t1perms(rs, [r | rs2], [Enum.reverse(rs2) ++ rs | acc])
end
