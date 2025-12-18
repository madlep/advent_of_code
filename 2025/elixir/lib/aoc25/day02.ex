defmodule Aoc25.Day02 do
  @spec part1(String.t()) :: integer()
  def part1(input), do: sum_repeated_digits(input, &repeat_2/1, 0)

  @spec part2(String.t()) :: integer()
  def part2(input), do: sum_repeated_digits(input, &repeat_any/1, 0)

  def repeat_2(_n), do: [2]

  def repeat_any(n) do
    len_digits = n |> Integer.digits() |> length()
    for i <- 2..len_digits//1, rem(len_digits, i) == 0, do: i
  end

  defp sum_repeated_digits("", _factors_fn, acc), do: acc

  defp sum_repeated_digits(<<c::utf8, input::binary>>, factors_fn, acc) when c in [?,, ?\n],
    do: sum_repeated_digits(input, factors_fn, acc)

  defp sum_repeated_digits(input, factors_fn, acc) do
    {num1, input} = Integer.parse(input)
    <<?-, input::binary>> = input
    {num2, input} = Integer.parse(input)

    new_acc = acc + (repeated_digits(num1, num2, factors_fn) |> Enum.sum())
    sum_repeated_digits(input, factors_fn, new_acc)
  end

  def repeated_digits(from, to, factors_fn) do
    (factors_fn.(from) ++ factors_fn.(to))
    |> Enum.uniq()
    |> Stream.flat_map(fn repeat_count ->
      from
      |> to_split_digits(repeat_count)
      |> Stream.unfold(fn split_digits ->
        {
          Integer.undigits(List.duplicate(split_digits, repeat_count) |> List.flatten()),
          Integer.digits(Integer.undigits(split_digits) + 1)
        }
      end)
      |> Stream.drop_while(&(&1 < from))
      |> Stream.take_while(&(&1 <= to))
    end)
    |> Stream.uniq()
  end

  def to_split_digits(n, repeat_count) do
    digits = Integer.digits(n)
    len_digits = length(digits)
    repeat_size = div(len_digits, repeat_count)

    if rem(len_digits, repeat_count) == 0 do
      Enum.take(digits, repeat_size)
    else
      [1 | List.duplicate(0, repeat_size)]
    end
  end
end
