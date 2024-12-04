defmodule Aoc24.Day04Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day04
  doctest Day04

  setup do
    example =
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day04.part1(ctx.example) == 18
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day04.part2(ctx.example) == 9
    end
  end
end
