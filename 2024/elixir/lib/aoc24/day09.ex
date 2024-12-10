defmodule Aoc24.Day09 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    disk = parse(input)

    disk
    |> compress(0, :array.size(disk) - 1)
    |> checksum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    disk = parse(input)

    disk
    |> compress_df(0, :array.size(disk) - 1)
    |> checksum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> parse(0, 0, :array.new(default: nil))
  end

  defp compress(disk, to_i, from_i) when to_i >= from_i, do: disk

  defp compress(disk, to_i, from_i) do
    case {:array.get(to_i, disk), :array.get(from_i, disk)} do
      {nil, from} when from != nil ->
        disk = :array.set(from_i, nil, disk)
        compress(:array.set(to_i, from, disk), to_i, from_i - 1)

      {nil, nil} ->
        compress(disk, to_i, from_i - 1)

      {to, _from} when to != nil ->
        compress(disk, to_i + 1, from_i)
    end
  end

  defp compress_df(disk, to_i, from_i) when to_i >= from_i, do: disk

  defp compress_df(disk, to_i, from_i) do
    case find_file(disk, from_i) do
      {:no_file, _from_i} ->
        disk

      {file_start, file_end} ->
        file_size = file_end - file_start + 1

        case find_gap(disk, to_i, file_start, file_size) do
          :no_gap ->
            disk |> compress_df(to_i, file_start - 1)

          {:gap, gap_start} ->
            disk
            |> move_file(file_start, gap_start, file_size)
            |> compress_df(0, file_start - 1)
        end
    end
  end

  defp find_file(disk, from_i) when from_i >= 0 do
    case :array.get(from_i, disk) do
      nil -> find_file(disk, from_i - 1)
      file_id -> {find_file_start(disk, file_id, from_i), from_i}
    end
  end

  defp find_file_start(_disk, _file_id, from_i) when from_i < 0, do: :no_file

  defp find_file_start(disk, file_id, from_i) do
    case :array.get(from_i, disk) do
      ^file_id -> find_file_start(disk, file_id, from_i - 1)
      _other_id -> from_i + 1
    end
  end

  defp find_gap(_disk, to_i, from_i, _size) when to_i >= from_i, do: :no_gap

  defp find_gap(disk, to_i, from_i, size) do
    if Enum.all?(to_i..(to_i + size - 1), fn i -> :array.get(i, disk) == nil end) do
      {:gap, to_i}
    else
      find_gap(disk, to_i + 1, from_i, size)
    end
  end

  defp move_file(disk, file_start, to_i, file_size) do
    0..(file_size - 1)
    |> Enum.reduce(disk, fn i, disk2 ->
      from = :array.get(file_start + i, disk2)
      disk2 = :array.set(file_start + i, nil, disk2)
      :array.set(to_i + i, from, disk2)
    end)
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
