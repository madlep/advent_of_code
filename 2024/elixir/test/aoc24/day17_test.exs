defmodule Aoc24.Day17Test do
  use ExUnit.Case, async: true

  alias Aoc24.Day17
  doctest Day17

  setup do
    example1 =
      """
      Register A: 729
      Register B: 0
      Register C: 0

      Program: 0,1,5,4,3,0
      """

    example2 =
      """
      Register A: 10
      Register B: 0
      Register C: 0

      Program: 5,0,5,1,5,4
      """

    example3 =
      """
      Register A: 2024
      Register B: 0
      Register C: 0

      Program: 0,1,5,4,3,0
      """

    {:ok, example1: example1, example2: example2, example3: example3}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day17.part1(ctx.example1) == "4,6,3,5,6,3,5,2,1,0"
      assert Day17.part1(ctx.example2) == "0,1,2"
      assert Day17.part1(ctx.example3) == "4,2,5,6,7,7,7,7,3,1,0"
    end
  end

  describe "execute/3" do
    test "adv" do
      assert Day17.execute(0, 0, {128, 0, 0}) == {128, 0, 0}
      assert Day17.execute(0, 1, {128, 0, 0}) == {64, 0, 0}
      assert Day17.execute(0, 1, {129, 0, 0}) == {64, 0, 0}
      assert Day17.execute(0, 1, {127, 0, 0}) == {63, 0, 0}
      assert Day17.execute(0, 2, {128, 0, 0}) == {32, 0, 0}
      assert Day17.execute(0, 3, {128, 0, 0}) == {16, 0, 0}
      assert Day17.execute(0, 4, {128, 5, 6}) == {0, 5, 6}
      assert Day17.execute(0, 5, {128, 5, 6}) == {4, 5, 6}
      assert Day17.execute(0, 6, {128, 5, 6}) == {2, 5, 6}
    end

    test "bxl" do
      assert Day17.execute(1, 7, {0, 29, 0}) == {0, 26, 0}
    end

    test "bst" do
      assert Day17.execute(2, 6, {0, 0, 9}) == {0, 1, 9}
    end

    test "jnz" do
      assert Day17.execute(3, 5, {0, 1, 2}) == {0, 1, 2}
      assert Day17.execute(3, 5, {3, 1, 2}) == {:jmp, 5}
    end

    test "bxc" do
      assert Day17.execute(4, 0, {0, 2024, 43690}) == {0, 44354, 43690}
    end

    test "out" do
      assert Day17.execute(5, 6, {0, 0, 9}) == {:out, 1}
    end

    test "bdv" do
      assert Day17.execute(6, 0, {128, 0, 0}) == {128, 128, 0}
      assert Day17.execute(6, 1, {128, 0, 0}) == {128, 64, 0}
      assert Day17.execute(6, 1, {129, 0, 0}) == {129, 64, 0}
      assert Day17.execute(6, 1, {127, 0, 0}) == {127, 63, 0}
      assert Day17.execute(6, 2, {128, 0, 0}) == {128, 32, 0}
      assert Day17.execute(6, 3, {128, 0, 0}) == {128, 16, 0}
      assert Day17.execute(6, 4, {128, 5, 6}) == {128, 0, 6}
      assert Day17.execute(6, 5, {128, 5, 6}) == {128, 4, 6}
      assert Day17.execute(6, 6, {128, 5, 6}) == {128, 2, 6}
    end

    test "cdv" do
      assert Day17.execute(7, 0, {128, 0, 0}) == {128, 0, 128}
      assert Day17.execute(7, 1, {128, 0, 0}) == {128, 0, 64}
      assert Day17.execute(7, 1, {129, 0, 0}) == {129, 0, 64}
      assert Day17.execute(7, 1, {127, 0, 0}) == {127, 0, 63}
      assert Day17.execute(7, 2, {128, 0, 0}) == {128, 0, 32}
      assert Day17.execute(7, 3, {128, 0, 0}) == {128, 0, 16}
      assert Day17.execute(7, 4, {128, 5, 6}) == {128, 5, 0}
      assert Day17.execute(7, 5, {128, 5, 6}) == {128, 5, 4}
      assert Day17.execute(7, 6, {128, 5, 6}) == {128, 5, 2}
    end
  end

  describe "part 2" do
    test "part 2" do
      example = """
      Register A: 38610541
      Register B: 0
      Register C: 0

      Program: 2,4,1,1,7,5,1,5,4,3,5,5,0,3,3,0
      """

      assert Day17.part2(example) == [164_278_899_142_333, 164_278_899_142_589]
    end
  end
end
