defmodule Aoc24.Day03Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day03
  doctest Day03

  setup do
    example =
      """
      xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day03.part1(ctx.example) == 161
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day03.part2(ctx.example) == 48
    end
  end
end
