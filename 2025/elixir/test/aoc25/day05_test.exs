defmodule Aoc25.Day05Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day05
  doctest Day05

  setup do
    example =
      """
      3-5
      10-14
      16-20
      12-18

      1
      5
      8
      11
      17
      32
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day05.part1(ctx.example) == 3
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day05.part2(ctx.example) == 14
    end
  end
end
