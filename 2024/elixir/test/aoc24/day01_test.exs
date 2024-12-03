defmodule Aoc24.Days.Day01Test do
  use ExUnit.Case, async: true

  alias Aoc24.Days.Day01
  doctest Day01

  setup do
    {:ok, io} =
      """
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
      """
      |> StringIO.open()

    example = IO.stream(io, :line)

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day01.part1(ctx.example) == 11
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day01.part2(ctx.example) == 31
    end
  end
end
