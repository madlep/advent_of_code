defmodule Aoc25.Day02Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day02
  doctest Day02

  setup do
    example =
      """
      11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day02.part1(ctx.example) == 1_227_775_554
    end
  end

  describe "to_split_digits/2" do
    test "generates split for numbers with even length" do
      assert Day02.to_split_digits(11) == [1]
      assert Day02.to_split_digits(1234) == [1, 2]
      assert Day02.to_split_digits(123_456) == [1, 2, 3]
    end

    test "skips to next split for numbers with odd length" do
      assert Day02.to_split_digits(1) == [1]
      assert Day02.to_split_digits(123) == [1, 0]
      assert Day02.to_split_digits(12345) == [1, 0, 0]
      assert Day02.to_split_digits(1_234_567) == [1, 0, 0, 0]
    end
  end

  describe "invalid_nums/2" do
    test "generates sequence from..to" do
      assert Day02.invalid_nums(11, 22) |> Enum.to_list() == [11, 22]
      assert Day02.invalid_nums(95, 115) |> Enum.to_list() == [99]
      assert Day02.invalid_nums(998, 1012) |> Enum.to_list() == [1010]
      assert Day02.invalid_nums(1_188_511_880, 1_188_511_890) |> Enum.to_list() == [1_188_511_885]
    end
  end

  describe "part 2" do
    @tag skip: "pending"
    test "part 2", ctx do
      assert Day02.part2(ctx.example) == :implement_me
    end
  end
end
