defmodule Aoc24.Day19Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day19
  doctest Day19

  setup do
    example =
      """
      r, wr, b, g, bwu, rb, gb, br

      brwrr
      bggr
      gbbr
      rrbgbr
      ubwu
      bwurrg
      brgr
      bbrgwb
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day19.part1(ctx.example) == 6
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day19.part2(ctx.example) == :implement_me
    end
  end
end
