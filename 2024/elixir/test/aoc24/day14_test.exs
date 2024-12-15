defmodule Aoc24.Day14Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day14
  doctest Day14

  setup do
    example =
      """
      p=0,4 v=3,-3
      p=6,3 v=-1,-3
      p=10,3 v=-1,2
      p=2,0 v=2,-1
      p=0,0 v=1,3
      p=3,0 v=-2,-2
      p=7,6 v=-1,-3
      p=3,0 v=-1,-2
      p=9,3 v=2,3
      p=7,3 v=-1,2
      p=2,4 v=2,-3
      p=9,5 v=-3,-3
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day14.part1(ctx.example, w: 11, h: 7) == 12
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day14.part2(ctx.example) == :implement_me
    end
  end
end
