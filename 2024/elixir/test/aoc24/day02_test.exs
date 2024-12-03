defmodule Aoc24.Day02Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day02
  doctest Day02

  setup do
    example =
      """
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day02.part1(ctx.example) == 2
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day02.part2(ctx.example) == 4
    end
  end
end
