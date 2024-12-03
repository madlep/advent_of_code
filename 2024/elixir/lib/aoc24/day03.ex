defmodule Aoc24.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse([], :do, :ignore_do)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse([], :do, :use_do)
    |> Enum.sum()
  end

  defp parse(<<>>, acc, _enabled, _use_enabled), do: acc

  defp parse("don't()" <> rest, acc, :do, :use_do), do: parse(rest, acc, :dont, :use_do)

  defp parse("do()" <> rest, acc, :dont, :use_do), do: parse(rest, acc, :do, :use_do)

  defp parse(<<_::utf8, rest::binary>>, acc, :dont, :use_do), do: parse(rest, acc, :dont, :use_do)

  defp parse(line, acc, enabled, use_enabled) do
    case mul(line) do
      {:ok, n, rest} -> parse(rest, [n | acc], enabled, use_enabled)
      {:error, rest} -> parse(rest, acc, enabled, use_enabled)
    end
  end

  defp mul(line) do
    with {:ok, rest} <- string("mul(", line),
         {:ok, n1, rest} <- digit(rest),
         {:ok, rest} <- string(",", rest),
         {:ok, n2, rest} <- digit(rest),
         {:ok, rest} <- string(")", rest) do
      {:ok, n1 * n2, rest}
    end
  end

  defp string(str, line) do
    case line do
      ^str <> rest -> {:ok, rest}
      <<_::utf8, rest::binary>> -> {:error, rest}
    end
  end

  defp digit(<<_::utf8, rest::binary>> = line) do
    case Integer.parse(line) do
      {n, rest} -> {:ok, n, rest}
      :error -> {:error, rest}
    end
  end
end
