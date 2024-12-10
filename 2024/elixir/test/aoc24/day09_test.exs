defmodule Aoc24.Day09Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day09
  doctest Day09

  setup do
    example =
      """
      2333133121414131402
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day09.part1(ctx.example) == 1928
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day09.part2(ctx.example) == 2858
    end
  end
end
