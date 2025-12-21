defmodule Aoc25.Day06Test do
  use ExUnit.Case, async: true

  alias Aoc25.Day06
  doctest Day06

  setup do
    example =
      """
      123 328  51 64 
       45 64  387 23 
        6 98  215 314
      *   +   *   +  
      """

    {:ok, example: example}
  end

  describe "part 1" do
    test "part 1", ctx do
      assert Day06.part1(ctx.example) == 4_277_556
    end
  end

  describe "part 2" do
    test "part 2", ctx do
      assert Day06.part2(ctx.example) == 3_263_827
    end
  end
end
