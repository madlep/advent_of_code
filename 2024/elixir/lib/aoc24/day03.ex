defmodule Aoc24.Days.Day03 do
  @spec part1(String.t()) :: integer()
  def part1(input) do
    input
    |> parse_line([])
    |> Enum.sum()
  end

  @spec part2(Enumerable.t(String.t())) :: integer()
  def part2(input) do
    input
    |> parse_line_enabled([], true)
    |> Enum.sum()
  end

  defp parse_line(<<>>, acc), do: acc

  defp parse_line(line, acc) do
    case mul(line) do
      {:ok, n, rest} -> parse_line(rest, [n | acc])
      {:error, rest} -> parse_line(rest, acc)
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

  defp parse_line_enabled(<<>>, acc, _enabled), do: acc

  defp parse_line_enabled(line, acc, true) do
    case string("don't()", line) do
      {:ok, rest} ->
        parse_line_enabled(rest, acc, false)

      {:error, _} ->
        case mul(line) do
          {:ok, n, rest} -> parse_line_enabled(rest, [n | acc], true)
          {:error, rest} -> parse_line_enabled(rest, acc, true)
        end
    end
  end

  defp parse_line_enabled(line, acc, false) do
    case string("do()", line) do
      {:ok, rest} -> parse_line_enabled(rest, acc, true)
      {:error, rest} -> parse_line_enabled(rest, acc, false)
    end
  end
end
