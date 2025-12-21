defmodule Aoc25.Day04Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day04
  doctest Day04

  setup do
    example =
      """
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day04.part1(ctx.example) == 13
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day04.part2(ctx.example) == :implement_me
    end
  end
end
