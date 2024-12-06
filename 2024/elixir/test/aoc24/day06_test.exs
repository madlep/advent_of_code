defmodule Aoc24.Day06Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day06
  doctest Day06

  setup do
    example =
      """
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day06.part1(ctx.example) == 41
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day06.part2(ctx.example) == 6
    end
  end
end
