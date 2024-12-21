defmodule Aoc24.Day18Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day18
  doctest Day18

  setup do
    example =
      """
      5,4
      4,2
      4,5
      3,0
      2,1
      6,3
      2,4
      1,5
      0,6
      3,3
      2,6
      5,1
      1,2
      5,5
      2,5
      6,5
      1,4
      0,4
      6,4
      1,1
      6,1
      1,0
      0,5
      1,6
      2,0
      """

    {:ok, example: example}
  end

  @test_width 6
  @test_height 6
  describe "part 1" do
    test "part 1", ctx do
      assert Day18.part1(ctx.example, 12, @test_width, @test_height) == 22
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day18.part2(ctx.example, @test_width, @test_height) == "6,1"
    end
  end
end
