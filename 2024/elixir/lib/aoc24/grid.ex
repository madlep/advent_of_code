defmodule Aoc24.Grid do
  alias Aoc24.Grid.Gridded
  alias Aoc24.Grid.Position

  @type t(v) :: Gridded.t(v)

  defguard in_bounds(position, w, h)
           when elem(position, 0) in 0..(w - 1)//1 and elem(position, 1) in 0..(h - 1)//1

  defdelegate at(g, position), to: Gridded
  defdelegate at!(g, position), to: Gridded

  @spec contains?(t(_v), Position.t()) :: boolean() when _v: var
  def contains?(g, {x, y}), do: x in xs(g) && y in ys(g)

  defdelegate delete(g, position), to: Gridded

  @spec positions(t(_v)) :: Enumerable.t({x :: integer(), y :: integer()}) when _v: var
  def positions(g), do: for(x <- xs(g), y <- ys(g), do: {x, y})

  defdelegate put(g, position, element), to: Gridded

  defdelegate put!(g, position, element), to: Gridded

  @spec move(t(v), from :: Position.t(), to :: Position.t()) :: t(v) when v: var
  def move(g, from, to), do: g |> put(to, at!(g, from)) |> delete(from)

  @spec xs(t(_v)) :: Range.t(integer()) when _v: var
  def xs(g), do: 0..(Gridded.width(g) - 1)

  @spec ys(t(_v)) :: Range.t(integer()) when _v: var
  def ys(g), do: 0..(Gridded.height(g) - 1)

  @spec print(t(_v)) :: String.t() when _v: var
  def print(g) do
    g
    |> ys()
    |> Enum.map(fn y ->
      g
      |> xs()
      |> Enum.map(fn x ->
        at(g, {x, y}) || " "
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end
