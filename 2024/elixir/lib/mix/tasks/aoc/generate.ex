defmodule Mix.Tasks.Aoc.Generate do
  @moduledoc "generate a new day"
  @shortdoc "generate new"

  use Mix.Task

  def run(args) do
    {parsed_args, []} = args |> OptionParser.parse!(strict: [day: :integer])

    day = Keyword.fetch!(parsed_args, :day)
    if day not in 1..25, do: raise("invalid day #{day}")
    day_num = day |> Integer.to_string() |> String.pad_leading(2, "0")
    generate_solution(day_num)
    generate_test(day_num)
  end

  defp generate_solution(day_num) do
    day_mod = Module.concat([:Aoc24, Days, :"Day#{day_num}"])
    if Code.ensure_loaded?(day_mod), do: raise("module #{day_mod} already exists")

    app_dir = File.cwd!()
    new_file_path = Path.join([app_dir, "lib", "aoc24", "day#{day_num}.ex"])

    if File.exists?(new_file_path), do: raise("file #{new_file_path} already exists")

    File.write(
      new_file_path,
      """
      defmodule #{Macro.to_string(day_mod)} do
        @spec part1(String.t()) :: integer()
        def part1(_input) do
          -1
        end

        @spec part2(String.t()) :: integer()
        def part2(_input) do
          -1
        end
      end
      """,
      [:write]
    )
  end

  defp generate_test(day_num) do
    test_mod = Module.concat([:Aoc24, Days, :"Day#{day_num}Test"])
    if Code.ensure_loaded?(test_mod), do: raise("module #{test_mod} already exists")

    day_mod = Module.concat([:Aoc24, Days, :"Day#{day_num}"])

    app_dir = File.cwd!()
    new_file_path = Path.join([app_dir, "test", "aoc24", "day#{day_num}_test.exs"])

    if File.exists?(new_file_path), do: raise("file #{new_file_path} already exists")

    File.write(
      new_file_path,
      """
      defmodule #{Macro.to_string(test_mod)} do
        use ExUnit.Case, async: true

        alias #{Macro.to_string(day_mod)}
        doctest Day#{day_num}

        setup do
          example =
            \"""
            EXAMPLE DATA HERE...
            \"""

          {:ok, example: example}
        end

        describe "part 1" do
          @tag skip: "pending"
          test "part 1", ctx do
            assert Day#{day_num}.part1(ctx.example) == :implement_me
          end
        end

        describe "part 2" do
          @tag skip: "pending"
          test "part 2", ctx do
            assert Day#{day_num}.part2(ctx.example) == :implement_me
          end
        end
      end
      """,
      [:write]
    )
  end
end
