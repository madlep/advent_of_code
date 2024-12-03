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
    |> parse_do([])
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
      IO.inspect("mul(#{n1},#{n2})")
      {:ok, n1 * n2, rest}
    end
  end

  defp string(str, line) do
    case line do
      ^str <> rest -> {:ok, rest}
      <<_::utf8, rest::binary>> -> {:error, rest}
    end
  end

  defp digit(line) do
    case Integer.parse(line) do
      {n, rest} ->
        {:ok, n, rest}

      :error ->
        <<_::utf8, rest::binary>> = line
        {:error, rest}
    end
  end

  defp parse_do(<<>>, acc), do: acc

  defp parse_do(line, acc) do
    case string("don't()", line) do
      {:ok, rest} ->
        IO.inspect("don't()")
        parse_dont(rest, acc)

      {:error, _} ->
        case mul(line) do
          {:ok, n, rest} -> parse_do(rest, [n | acc])
          {:error, rest} -> parse_do(rest, acc)
        end
    end
  end

  defp parse_dont(<<>>, acc), do: acc

  defp parse_dont(line, acc) do
    case string("do()", line) do
      {:ok, rest} ->
        IO.inspect("do()")
        parse_do(rest, acc)

      {:error, rest} ->
        parse_dont(rest, acc)
    end
  end
end
