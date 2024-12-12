defmodule Aoc24.Day11Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day11
  doctest Day11

  setup do
    example =
      """
      125 17
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day11.part1(ctx.example) == 55312
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day11.part2(ctx.example) == :implement_me
    end
  end
end
