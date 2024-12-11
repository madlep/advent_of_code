defmodule Aoc24.Grid.Dense do
  import Aoc24.Grid

  @opaque t(_v) :: {contents :: tuple(), width :: integer, height :: integer}

  @spec new(tuple()) :: t(_v) when _v: var
  def new(contents) do
    width = tuple_size(elem(contents, 0))
    height = tuple_size(contents)

    {contents, width, height}
  end

  @spec xs(t(_v)) :: Range.t(integer()) when _v: var
  def xs({_, width, _height}), do: 0..(width - 1)

  @spec ys(t(_v)) :: Range.t(integer()) when _v: var
  def ys({_, _width, height}), do: 0..(height - 1)

  @spec at!(t(v), Grid.position()) :: v when v: var
  def at!({contents, width, height}, {x, y} = position) when in_bounds(position, width, height) do
    contents |> elem(y) |> elem(x)
  end

  @spec at(t(v), Grid.position()) :: v when v: var
  def at({contents, width, height}, {x, y} = position) when in_bounds(position, width, height) do
    contents |> elem(y) |> elem(x)
  end

  def at(_, _), do: nil

  @spec contains?(t(_v), Grid.position()) :: boolean() when _v: var
  def contains?({_contents, w, h}, position) when in_bounds(position, w, h), do: true
  def contains?({_contents, _w_, _h}, _position), do: false
end
