defmodule Aoc24.Day16Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day16
  doctest Day16

  setup do
    example1 =
      """
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
      """

    example2 = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    """

    {:ok, example1: example1, example2: example2}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day16.part1(ctx.example1) == 7036
      assert Day16.part1(ctx.example2) == 11048
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day16.part2(ctx.example1) == 45
      assert Day16.part2(ctx.example2) == 64
    end
  end
end
