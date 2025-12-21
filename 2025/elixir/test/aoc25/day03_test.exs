defmodule Aoc25.Day03Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day03
  doctest Day03

  setup do
    example =
      """
      987654321111111
      811111111111119
      234234234234278
      818181911112111
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day03.part1(ctx.example) == 357
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day03.part2(ctx.example) == 3_121_910_778_619
    end
  end

  describe "largest_jolt/2" do
    defmacrop assert_largest_jolt(bank, batteries, expected) do
      quote do
        assert unquote(bank) |> Integer.digits() |> Day03.largest_jolt(unquote(batteries)) ==
                 unquote(expected)
      end
    end

    test "calculates largest jolt turning on 2 batteries" do
      assert_largest_jolt(987_654_321_111_111, 2, 98)
      assert_largest_jolt(811_111_111_111_119, 2, 89)
      assert_largest_jolt(234_234_234_234_278, 2, 78)
      assert_largest_jolt(818_181_911_112_111, 2, 92)
    end

    test "calcualtes largest jolt turning on 12 batteries" do
      assert_largest_jolt(987_654_321_111_111, 12, 987_654_321_111)
      assert_largest_jolt(811_111_111_111_119, 12, 811_111_111_119)
      assert_largest_jolt(234_234_234_234_278, 12, 434_234_234_278)
      assert_largest_jolt(818_181_911_112_111, 12, 888_911_112_111)
    end
  end
end
