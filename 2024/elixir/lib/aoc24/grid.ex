defmodule Aoc24.Grid do
  alias Aoc24.Grid.Gridded

  defmodule Position do
    @type t() :: {x :: integer(), y :: integer()}

    @spec new(x :: integer(), y :: integer()) :: t()
    def new(x, y), do: {x, y}

    @neighbour_dirs [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]

    @spec neighbours(t()) :: Enumerable.t(t())
    def neighbours({x, y}), do: for({dx, dy} <- @neighbour_dirs, do: {x + dx, y + dy})
  end

  defguard in_bounds(position, w, h)
           when elem(position, 0) in 0..(w - 1)//1 and elem(position, 1) in 0..(h - 1)//1

  defdelegate at(g, position), to: Gridded
  defdelegate at!(g, position), to: Gridded

  @spec contains?(Gridded.t(_v), Aoc24.Position.t()) :: boolean() when _v: var
  def contains?(g, {x, y}), do: x in xs(g) && y in ys(g)

  @spec positions(Gridded.t(_v)) :: Enumerable.t({x :: integer(), y :: integer()}) when _v: var
  def positions(g), do: for(x <- xs(g), y <- ys(g), do: {x, y})

  defdelegate put(g, position, element), to: Gridded

  @spec xs(Aoc24.Gridded.t(_v)) :: Range.t(integer()) when _v: var
  def xs(g), do: 0..(Gridded.width(g) - 1)

  @spec ys(Aoc24.Gridded.t(_v)) :: Range.t(integer()) when _v: var
  def ys(g), do: 0..(Gridded.height(g) - 1)
end
