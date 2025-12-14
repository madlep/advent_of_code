defmodule Aoc25.Day02 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    do_part1(input, 0)
  end

  @spec part2(String.t()) :: integer()
  def part2(_input) do
    -1
  end

  defp do_part1("", acc), do: acc

  defp do_part1(<<c::utf8, input::binary>>, acc) when c in [?,, ?\n], do: do_part1(input, acc)

  defp do_part1(input, acc) do
    {num1, input} = Integer.parse(input)
    <<?-, input::binary>> = input
    {num2, input} = Integer.parse(input)
    new_acc = acc + (invalid_nums(num1, num2) |> Enum.sum())
    do_part1(input, new_acc)
  end

  def to_split_digits(n) do
    digits = Integer.digits(n)
    len_digits = length(digits)

    if rem(len_digits, 2) == 0 do
      Enum.take(digits, div(len_digits, 2))
    else
      [1 | List.duplicate(0, div(len_digits, 2))]
    end
  end

  def invalid_nums(from, to) do
    from
    |> to_split_digits()
    |> Stream.unfold(fn split_digits ->
      {
        Integer.undigits(split_digits ++ split_digits),
        Integer.digits(Integer.undigits(split_digits) + 1)
      }
    end)
    |> Stream.drop_while(&(&1 < from))
    |> Stream.take_while(&(&1 <= to))
  end
end
