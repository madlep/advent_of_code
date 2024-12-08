defmodule Aoc24.Parse do
  alias Aoc24.Grid
  alias Aoc24.Grid.Dense
  alias Aoc24.Grid.Sparse

  @spec drop(String.t(), to_drop :: String.t()) :: String.t()
  def drop(str, to_drop) do
    drop_size = byte_size(to_drop)
    <<_::binary-size(drop_size), rest::binary>> = str
    rest
  end

  defdelegate int(str), to: Integer, as: :parse

  @spec ints(String.t(), sep :: String.pattern() | Regex.t()) :: Enumerable.t(integer())
  def ints(str, sep \\ " ") do
    str
    |> String.split(sep, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @spec lines(String.t()) :: Enumerable.t(String.t())
  def lines(str) do
    String.split(str, "\n", trim: true)
  end

  @spec grid(String.t()) :: Dense.t(_v) when _v: var
  def grid(str) do
    str
    |> lines()
    |> Enum.map(&(&1 |> String.graphemes() |> List.to_tuple()))
    |> List.to_tuple()
    |> Dense.new()
  end

  @spec grid_lines_wh(Enumerable.t(String.t())) :: {width :: integer(), height :: integer()}
  def grid_lines_wh(lines) do
    width = lines |> hd() |> byte_size()
    height = length(lines)
    {width, height}
  end

  @type sparse_grid_opt(v, sparse_grid_acc) ::
          {:empty, Enumerable.t(String.t())}
          | {:reduce_with, {sparse_grid_reducer(v, sparse_grid_acc), sparse_grid_acc}}

  @type sparse_grid_reducer(v, sparse_grid_acc) :: ({Grid.position(), String.t()},
                                                    sparse_grid_acc ->
                                                      {:keep, element :: v, sparse_grid_acc}
                                                      | {:discard, sparse_grid_acc})

  @spec sparse_grid(Enumerable.t(String.t()), opts :: [sparse_grid_opt(v, sparse_grid_acc)]) ::
          {Sparse.t(v), sparse_grid_acc}
        when v: var, sparse_grid_acc: var
  def sparse_grid(input, opts \\ []) do
    empty = opts[:empty] || ["."]

    {f, initial_acc} = opts[:reduce_with] || {&default_sparse_grid_reducer/2, nil}

    lines = lines(input)

    initial_grid = Sparse.new(grid_lines_wh(lines))

    lines
    |> Enum.with_index()
    |> Enum.reduce({initial_grid, initial_acc}, fn {line, y}, grid_acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(grid_acc, fn
        {element, x}, {grid, acc} ->
          if element not in empty do
            position = {x, y}

            case f.({position, element}, acc) do
              {:keep, element2, new_acc} ->
                new_grid = Sparse.put(grid, position, element2)
                {new_grid, new_acc}

              {:discard, new_acc} ->
                {grid, new_acc}
            end
          else
            {grid, acc}
          end
      end)
    end)
  end

  defp default_sparse_grid_reducer({_position, element}, acc), do: {:keep, element, acc}
end
