defmodule Aoc24.Grid.Dense do
  import Aoc24.Grid, only: [in_bounds: 3]

  @enforce_keys [:contents, :w, :h]
  defstruct [:contents, :w, :h]

  @opaque t(_v) :: %__MODULE__{contents: tuple(), w: integer(), h: integer()}

  @spec new(tuple()) :: t(_v) when _v: var
  def new(contents) do
    w = tuple_size(elem(contents, 0))
    h = tuple_size(contents)

    %__MODULE__{contents: contents, w: w, h: h}
  end

  @spec at!(t(v), Grid.position()) :: v when v: var
  def at!(%__MODULE__{w: w, h: h} = g, {x, y} = position) when in_bounds(position, w, h) do
    g.contents |> elem(y) |> elem(x)
  end

  @spec at(t(v), Grid.position()) :: v when v: var
  def at(%__MODULE__{w: w, h: h} = g, {x, y} = position) when in_bounds(position, w, h) do
    g.contents |> elem(y) |> elem(x)
  end

  def at(_, _), do: nil

  defimpl Aoc24.Gridded do
    defdelegate at(g, position), to: Aoc24.Grid.Dense
    defdelegate at!(g, position), to: Aoc24.Grid.Dense
    def put(_g, _position, _element), do: raise("not supported for read only dense grids")
    def height(%Aoc24.Grid.Dense{h: h}), do: h
    def width(%Aoc24.Grid.Dense{w: w}), do: w
  end
end
