defmodule Aoc24.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse([], true, :ignore)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse([], true, :use)
    |> Enum.sum()
  end

  defp parse(<<>>, acc, _enabled, _use_enabled), do: acc

  defp parse("don't()" <> rest, acc, true, :use), do: parse(rest, acc, false, :use)

  defp parse(line, acc, true, use_enabled) do
    case mul(line) do
      {:ok, n, rest} -> parse(rest, [n | acc], true, use_enabled)
      {:error, rest} -> parse(rest, acc, true, use_enabled)
    end
  end

  defp parse("do()" <> rest, acc, false, :use), do: parse(rest, acc, true, :use)

  defp parse(<<_::utf8, rest::binary>>, acc, false, :use), do: parse(rest, acc, false, :use)

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
