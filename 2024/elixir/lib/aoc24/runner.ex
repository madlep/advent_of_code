defmodule Aoc24.Runner do
  def run(day, part) do
    if day not in 1..25, do: raise("invalid day #{day}")
    day_num = day |> Integer.to_string() |> String.pad_leading(2, "0")
    day_mod = Module.concat([:Aoc24, Days, :"Day#{day_num}"])
    if not Code.ensure_loaded?(day_mod), do: raise("#{day_mod} doesn't exist")

    if part not in 1..2, do: raise("invalid part #{part}")
    part_fn = :"part#{part}"

    if not function_exported?(day_mod, part_fn, 1),
      do: raise("#{day_mod} doesn't implement #{part_fn}")

    apply(day_mod, part_fn, [data(day)])
  end

  def data(day) do
    day_num = day |> Integer.to_string() |> String.pad_leading(2, "0")
    data_file_name = "day#{day_num}.txt"
    data_file = Path.join([:code.priv_dir(:aoc24), data_file_name])
    if not File.exists?(data_file), do: raise("no data file #{data_file_name} for day #{day_num}")
    File.stream!(data_file)
  end
end
