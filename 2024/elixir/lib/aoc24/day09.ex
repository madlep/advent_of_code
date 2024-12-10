defmodule Aoc24.Day09 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    disk = parse(input)

    disk
    |> compress(0, :array.size(disk) - 1)
    |> checksum()
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp parse(input) do
    input
    |> String.trim()
    |> parse(0, 0, :array.new(default: nil))
  end

  defp compress(disk, to_id, from_id) when to_id >= from_id, do: disk

  defp compress(disk, to_id, from_id) do
    case :array.get(to_id, disk) do
      nil ->
        case :array.get(from_id, disk) do
          from when from != nil ->
            disk = :array.set(from_id, nil, disk)
            compress(:array.set(to_id, from, disk), to_id, from_id - 1)

          nil ->
            compress(disk, to_id, from_id - 1)
        end

      to when to != nil ->
        compress(disk, to_id + 1, from_id)
    end
  end

  defp checksum(disk), do: :array.sparse_foldl(fn i, id, sum -> sum + i * id end, 0, disk)

  defp parse(<<f::utf8, g::utf8, rest::binary>>, id, offset, disk)
       when f in ?0..?9 and g in ?0..?9 do
    f = f - ?0
    g = g - ?0

    parse(rest, id + 1, offset + f + g, write_file(id, offset, f, disk))
  end

  defp parse(<<f::utf8>>, id, offset, disk) when f in ?0..?9 do
    f = f - ?0
    write_file(id, offset, f, disk)
  end

  defp write_file(id, offset, size, disk) do
    offset..(offset + size - 1)
    |> Enum.reduce(disk, fn offset2, disk2 -> :array.set(offset2, id, disk2) end)
  end
end
