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

    example4 =
      """
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
      """

    example5 =
      """
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
      """

    {:ok,
     example1: example1,
     example2: example2,
     example3: example3,
     example4: example4,
     example5: example5}
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
    test "part 2 example1", ctx do
      assert Day12.part2(ctx.example1) == 80
    end

    test "part 2 example2", ctx do
      assert Day12.part2(ctx.example2) == 436
    end

    test "part 2 example3", ctx do
      assert Day12.part2(ctx.example3) == 1206
    end

    test "part 2 example4", ctx do
      assert Day12.part2(ctx.example4) == 236
    end

    test "part 2 example5", ctx do
      assert Day12.part2(ctx.example5) == 368
    end
  end
end
