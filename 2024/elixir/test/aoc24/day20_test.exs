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
    test "part 2", ctx do
      # There are 3 cheats that save 76 picoseconds
      assert Day20.part2(ctx.example, 76) == 3

      # There are 4 cheats that save 74 picoseconds.
      assert Day20.part2(ctx.example, 74) == 7

      # There are 22 cheats that save 72 picoseconds.
      assert Day20.part2(ctx.example, 72) == 29

      # There are 12 cheats that save 70 picoseconds.
      assert Day20.part2(ctx.example, 70) == 41

      # There are 14 cheats that save 68 picoseconds.
      assert Day20.part2(ctx.example, 68) == 55

      # There are 12 cheats that save 66 picoseconds.
      assert Day20.part2(ctx.example, 66) == 67

      # There are 19 cheats that save 64 picoseconds.
      assert Day20.part2(ctx.example, 64) == 86

      # There are 20 cheats that save 62 picoseconds.
      assert Day20.part2(ctx.example, 62) == 106

      # There are 23 cheats that save 60 picoseconds.
      assert Day20.part2(ctx.example, 60) == 129

      # There are 25 cheats that save 58 picoseconds.
      assert Day20.part2(ctx.example, 58) == 154

      # There are 39 cheats that save 56 picoseconds.
      assert Day20.part2(ctx.example, 56) == 193

      # There are 29 cheats that save 54 picoseconds.
      assert Day20.part2(ctx.example, 54) == 222

      # There are 31 cheats that save 52 picoseconds.
      assert Day20.part2(ctx.example, 52) == 253

      # There are 32 cheats that save 50 picoseconds.
      assert Day20.part2(ctx.example, 50) == 285
    end
  end
end
