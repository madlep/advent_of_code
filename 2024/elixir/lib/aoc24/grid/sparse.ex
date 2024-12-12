defmodule Aoc24.Grid.Sparse do
  import Aoc24.Grid, only: [in_bounds: 3]

  @enforce_keys [:contents, :w, :h]
  defstruct [:contents, :w, :h]

  @opaque t(_v) :: %__MODULE__{contents: map(), w: integer(), h: integer()}

  @spec new(w :: integer(), h :: integer()) :: t(_v) when _v: var
  def new(w, h) do
    %__MODULE__{contents: %{}, w: w, h: h}
  end

  @spec put(t(v), Grid.position(), v) :: t(v) when v: var
  def put(%__MODULE__{w: w, h: h} = g, position, element) when in_bounds(position, w, h) do
    %__MODULE__{g | contents: Map.put(g.contents, position, element)}
  end

  @spec at!(t(v), Grid.position()) :: v when v: var
  def at!(%__MODULE__{w: w, h: h} = g, position) when in_bounds(position, w, h) do
    at(g, position)
  end

  @spec at(t(v), Grid.position()) :: v when v: var
  def at(g, position) do
    g.contents[position]
  end

  defimpl Aoc24.Gridded do
    defdelegate at(g, position), to: Aoc24.Grid.Sparse
    defdelegate at!(g, position), to: Aoc24.Grid.Sparse
    defdelegate put(g, position, element), to: Aoc24.Grid.Sparse
    def height(%Aoc24.Grid.Sparse{h: h}), do: h
    def width(%Aoc24.Grid.Sparse{w: w}), do: w
  end
end
