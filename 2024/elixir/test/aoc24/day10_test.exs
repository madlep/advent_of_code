defmodule Aoc24.Day10Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day10
  doctest Day10

  setup do
    example =
      """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day10.part1(ctx.example) == 36
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day10.part2(ctx.example) == 81
    end
  end
end
