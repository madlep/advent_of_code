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

    part = Keyword.fetch!(parsed_args, :part)
    if part not in 1..2, do: raise("invalid part #{part}")

    IO.puts("Running day:#{day} part:#{part}")
    IO.inspect(Aoc24.Runner.run(day, part))
  end
end
