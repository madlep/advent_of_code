defmodule Aoc24.Day12Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day12
  doctest Day12

  setup do
    example1 =
      """
      AAAA
      BBCD
      BBCC
      EEEC
      """

    example2 =
      """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      """

    example3 =
      """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
      """

    {:ok, example1: example1, example2: example2, example3: example3}
  end

  describe "part 1" do
    test "part 1 example1", ctx do
      assert Day12.part1(ctx.example1) == 140
    end

    test "part 1 example2", ctx do
      assert Day12.part1(ctx.example2) == 772
    end

    test "part 1 example3", ctx do
      assert Day12.part1(ctx.example3) == 1930
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day12.part2(ctx.example) == :implement_me
    end
  end
end
