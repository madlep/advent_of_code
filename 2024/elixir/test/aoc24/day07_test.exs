defmodule Aoc24.Day07Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day07
  doctest Day07

  setup do
    example =
      """
      190: 10 19
      3267: 81 40 27
      83: 17 5
      156: 15 6
      7290: 6 8 6 15
      161011: 16 10 13
      192: 17 8 14
      21037: 9 7 18 13
      292: 11 6 16 20
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day07.part1(ctx.example) == 3749
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day07.part2(ctx.example) == 11387
    end
  end
end
