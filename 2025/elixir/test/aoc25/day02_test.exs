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

  describe "to_split_digits/3" do
    test "generates split for numbers with even length" do
      assert Day02.to_split_digits(11, 2) == [1]
      assert Day02.to_split_digits(1234, 2) == [1, 2]
      assert Day02.to_split_digits(123_456, 2) == [1, 2, 3]
    end

    test "skips to next split for numbers with odd length" do
      assert Day02.to_split_digits(1, 2) == [1]
      assert Day02.to_split_digits(123, 2) == [1, 0]
      assert Day02.to_split_digits(12345, 2) == [1, 0, 0]
      assert Day02.to_split_digits(1_234_567, 2) == [1, 0, 0, 0]
    end
  end

  describe "repeated_digits/2" do
    defmacro assert_repeat_2(from, to, expected) do
      quote do
        assert Day02.repeated_digits(unquote(from), unquote(to), &Day02.repeat_2/1)
               |> Enum.to_list() == unquote(expected)
      end
    end

    defmacro assert_repeat_any(from, to, expected) do
      quote do
        assert Day02.repeated_digits(unquote(from), unquote(to), &Day02.repeat_any/1)
               |> Enum.to_list() == unquote(expected)
      end
    end

    test "generates sequence from..to with 2 repeats" do
      assert_repeat_2(11, 22, [11, 22])
      assert_repeat_2(95, 115, [99])
      assert_repeat_2(998, 1012, [1010])
      assert_repeat_2(1_188_511_880, 1_188_511_890, [1_188_511_885])
      assert_repeat_2(222_220, 222_224, [222_222])
      assert_repeat_2(1_698_522, 1_698_528, [])
      assert_repeat_2(446_443, 446_449, [446_446])
      assert_repeat_2(38_593_856, 38_593_862, [38_593_859])
    end

    test "generates sequence from..to with any number of repeats" do
      assert_repeat_any(11, 22, [11, 22])
      assert_repeat_any(95, 115, [99, 111])
      assert_repeat_any(998, 1012, [999, 1010])
      assert_repeat_any(1_188_511_880, 1_188_511_890, [1_188_511_885])
      assert_repeat_any(222_220, 222_224, [222_222])
      assert_repeat_any(1_698_522, 1_698_528, [])
      assert_repeat_any(446_443, 446_449, [446_446])
      assert_repeat_any(38_593_856, 38_593_862, [38_593_859])
      assert_repeat_any(565_653, 565_659, [565_656])
      assert_repeat_any(824_824_821, 824_824_827, [824_824_824])
      assert_repeat_any(2_121_212_118, 2_121_212_124, [2_121_212_121])
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day02.part2(ctx.example) == 4_174_379_265
    end
  end
end
