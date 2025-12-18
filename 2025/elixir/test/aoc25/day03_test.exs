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
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day03.part2(ctx.example) == -2
    end
  end

  describe "largest_jolt/1" do
    test "calculates largest jolt turning on 2 batteries" do
      assert 987_654_321_111_111 |> Integer.digits() |> Aoc25.Day03.largest_jolt() == 98
      assert 811_111_111_111_119 |> Integer.digits() |> Aoc25.Day03.largest_jolt() == 89
      assert 234_234_234_234_278 |> Integer.digits() |> Aoc25.Day03.largest_jolt() == 78
      assert 818_181_911_112_111 |> Integer.digits() |> Aoc25.Day03.largest_jolt() == 92
    end
  end
end
