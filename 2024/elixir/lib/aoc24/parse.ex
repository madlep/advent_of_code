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

  def line!(str) do
    [line] = lines(str)
    line
  end

  defdelegate int(str), to: Integer, as: :parse

  defdelegate int!(str), to: String, as: :to_integer

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

  @type grid_reducer(v, acc) :: ({Grid.position(), String.t()}, acc ->
                                   {:keep, element :: v, acc} | {:discard, acc})

  @type grid_opt(v, acc) ::
          {:empty_value, term()}
          | {:reduce_with, {grid_reducer(v, acc), acc}}
          | {:reduce_with, grid_reducer(v, acc)}

  @spec grid(String.t(), opts :: [grid_opt(v, acc)]) :: {Dense.t(v), acc} when v: var, acc: var
  def grid(str, opts \\ []) do
    empty_value = opts[:empty_value] || nil
    reduce_with = opts[:reduce_with] || {&default_grid_reducer/2, nil}

    {f, initial_acc} =
      case reduce_with do
        {f, initial_acc} -> {f, initial_acc}
        f when is_function(f) -> {f, nil}
      end

    {tuples, new_acc} =
      str
      |> lines()
      |> Enum.with_index()
      |> Enum.map_reduce(initial_acc, fn {line, y}, acc ->
        {lines, new_acc} =
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.map_reduce(acc, fn {element, x}, acc2 ->
            position = {x, y}

            case f.({position, element}, acc2) do
              {:keep, element2, new_acc} -> {element2, new_acc}
              {:discard, new_acc} -> {empty_value, new_acc}
            end
          end)

        {List.to_tuple(lines), new_acc}
      end)

    {tuples |> List.to_tuple() |> Dense.new(), new_acc}
  end

  @spec grid_lines_wh(Enumerable.t(String.t())) :: {width :: integer(), height :: integer()}
  def grid_lines_wh(lines) do
    width = lines |> hd() |> byte_size()
    height = length(lines)
    {width, height}
  end

  #  @type sparse_grid_opt(v, acc) ::
  #          {:empty, Enumerable.t(String.t())}
  #          | {:reduce_with, {grid_reducer(v, acc), acc}}
  #          | {:reduce_with, grid_reducer(v, acc)}

  @spec sparse_grid(Enumerable.t(String.t()), opts :: [grid_opt(v, acc)]) ::
          {Sparse.t(v), acc}
        when v: var, acc: var
  def sparse_grid(input, opts \\ []) do
    empty = opts[:empty] || ["."]

    reduce_with = opts[:reduce_with] || {&default_grid_reducer/2, nil}

    {f, initial_acc} =
      case reduce_with do
        {f, initial_acc} -> {f, initial_acc}
        f when is_function(f) -> {f, nil}
      end

    lines = lines(input)

    {w, h} = grid_lines_wh(lines)
    initial_grid = Sparse.new(w, h)

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

  defp default_grid_reducer({_position, element}, acc), do: {:keep, element, acc}
end
