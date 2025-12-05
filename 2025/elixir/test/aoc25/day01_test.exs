defmodule Aoc25.Day01Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day01
  doctest Day01

  setup do
    example =
      """
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day01.part1(ctx.example) == 3
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day01.part2(ctx.example) == 6
    end
  end
end
