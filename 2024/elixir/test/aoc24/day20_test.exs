defmodule Aoc24.Day20Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day20
  doctest Day20

  setup do
    example =
      """
      ###############
      #...#...#.....#
      #.#.#.#.#.###.#
      #S#...#.#.#...#
      #######.#.#.###
      #######.#.#...#
      #######.#.###.#
      ###..E#...#...#
      ###.#######.###
      #...###...#...#
      #.#####.#.###.#
      #.#...#.#.#...#
      #.#.#.#.#.#.###
      #...#...#...###
      ###############
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day20.part1(ctx.example, 2) == 44
      assert Day20.part1(ctx.example, 4) == 30
      assert Day20.part1(ctx.example, 6) == 16
      assert Day20.part1(ctx.example, 8) == 14
      assert Day20.part1(ctx.example, 10) == 10
      assert Day20.part1(ctx.example, 12) == 8
      assert Day20.part1(ctx.example, 20) == 5
      assert Day20.part1(ctx.example, 36) == 4
      assert Day20.part1(ctx.example, 38) == 3
      assert Day20.part1(ctx.example, 40) == 2
      assert Day20.part1(ctx.example, 64) == 1
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day20.part2(ctx.example) == :implement_me
    end
  end
end
