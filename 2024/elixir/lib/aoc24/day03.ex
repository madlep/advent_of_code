defmodule Aoc24.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse([])
    |> Enum.sum()
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    input
    |> parse_enabled([], :do)
    |> Enum.sum()
  end

  defp parse(<<>>, acc), do: acc

  defp parse(line, acc) do
    case mul(line) do
      {:ok, n, rest} -> parse(rest, [n | acc])
      {:error, rest} -> parse(rest, acc)
    end
  end

  defp parse_enabled(<<>>, acc, _enabled), do: acc

  defp parse_enabled(line, acc, :do) do
    case string("don't()", line) do
      {:ok, rest} ->
        parse_enabled(rest, acc, :dont)

      {:error, _} ->
        case mul(line) do
          {:ok, n, rest} -> parse_enabled(rest, [n | acc], :do)
          {:error, rest} -> parse_enabled(rest, acc, :do)
        end
    end
  end

  defp parse_enabled(line, acc, :dont) do
    case string("do()", line) do
      {:ok, rest} -> parse_enabled(rest, acc, :do)
      {:error, rest} -> parse_enabled(rest, acc, :dont)
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
