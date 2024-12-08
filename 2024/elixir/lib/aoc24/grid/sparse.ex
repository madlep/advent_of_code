defmodule Aoc24.Grid.Sparse do
  import Aoc24.Grid

  @opaque t(_v) :: {contents :: map(), width :: integer, height :: integer}

  @spec new({w :: integer(), h :: integer()}) :: t(_v) when _v: var
  def new({w, h}) do
    {%{}, w, h}
  end

  @spec put(t(v), Grid.position(), v) :: t(v) when v: var
  def put({contents, w, h}, position, element) when in_bounds(position, w, h) do
    {Map.put(contents, position, element), w, h}
  end

  @spec at!(t(v), Grid.position()) :: v when v: var
  def at!({_contents, w, h} = grid, position) when in_bounds(position, w, h) do
    at(grid, position)
  end

  @spec at(t(v), Grid.position()) :: v when v: var
  def at({contents, _w, _h}, position) do
    Map.get(contents, position)
  end

  @spec contains?(t(_v), Grid.position()) :: boolean() when _v: var
  def contains?({_contents, w, h}, position) when in_bounds(position, w, h), do: true
  def contains?({_contents, _w_, _h}, _position), do: false
end
