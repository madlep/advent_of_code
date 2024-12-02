defmodule Mix.Tasks.Aoc.Run do
  @moduledoc "run advent of code day"
  @shortdoc "run day/part"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {parsed_args, []} = args |> OptionParser.parse!(strict: [day: :integer, part: :integer])

    if parsed_args[:all] do
      raise "--all not implemented yet"
    end

    day = Keyword.fetch!(parsed_args, :day)
    if day not in 1..25, do: raise("invalid day #{day}")
    day_num = day |> Integer.to_string() |> String.pad_leading(2, "0")
    day_mod = Module.concat([:Aoc24, Days, :"Day#{day_num}"])
    if not Code.ensure_loaded?(day_mod), do: raise("#{day_mod} doesn't exist")

    part = Keyword.fetch!(parsed_args, :part)
    if part not in 1..2, do: raise("invalid part #{part}")
    part_fn = :"part#{part}"

    if not function_exported?(day_mod, part_fn, 1),
      do: raise("#{day_mod} doesn't implement #{part_fn}")

    data_file_name = "day#{day_num}.txt"
    data_file = Path.join([:code.priv_dir(:aoc24), data_file_name])
    if not File.exists?(data_file), do: raise("no data file #{data_file_name} for day #{day_num}")
    data = File.stream!(data_file)

    IO.puts("Running day:#{day} part:#{part}")
    result = apply(day_mod, part_fn, [data])
    IO.inspect(result)
  end
end
