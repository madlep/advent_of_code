defmodule Aoc24.Day08Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day08
  doctest Day08

  setup do
    example =
      """
      ............
      ........0...
      .....0......
      .......0....
      ....0.......
      ......A.....
      ............
      ............
      ........A...
      .........A..
      ............
      ............
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day08.part1(ctx.example) == 14
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day08.part2(ctx.example) == :implement_me
    end
  end
end
